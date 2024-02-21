Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38D979DBC;
	Wed, 21 Feb 2024 13:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523126; cv=none; b=sV47ouREZQcoDIQ/JxcL7RfynPvYAoHTXbjUCFt8vnRaHvaWbVDIcMp35WPTyvLjG4GbTlvaJUBLBxn4bWiSmWeiCI8o+Xj3DCgW6FIsBJve4ziHdg2mx1eX2+CXg4qSN4mrhDQN042IvlHgI6CeTsfvrp8X3BV4/POAn0CW3ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523126; c=relaxed/simple;
	bh=TUOWCmHJFs5rU1Emt/V1NA0n16Aa+ZpTG432rziKkA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXfUPCB075MNr9SD6CYa9eX2oUi5tLkrhKbV38H+gIa6snzwbL0wPkepFUyecliopCeAjv5U/FexaltUYZP5SXUbiq50N1EEdTXY3bcJh73meB+QJJqpG6ZYgnoMZgpTtkoQIDF2L2WqX51UIYQL/En3l/ZAqgv+dKr24p2Ujj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y4jqshk1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y4jqshk1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32ED0C433C7;
	Wed, 21 Feb 2024 13:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523126;
	bh=TUOWCmHJFs5rU1Emt/V1NA0n16Aa+ZpTG432rziKkA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y4jqshk1r43r49u3ysF4FGdaaDjJziaqaVpGQbC6pwtO87S8d13Kswzm3UlMh+vF1
	 so5mqmMB9SPSvbZ54GTSjWRINKtyAPYrpbQrHhIQ+ZSnI2n0cYR9KqG7uS6qiK1F/t
	 UddB+BmSmGOf8RTKYiWbsXhQI6yEA7q6m12fSeS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 347/476] btrfs: send: return EOPNOTSUPP on unknown flags
Date: Wed, 21 Feb 2024 14:06:38 +0100
Message-ID: <20240221130020.814105061@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

commit f884a9f9e59206a2d41f265e7e403f080d10b493 upstream.

When some ioctl flags are checked we return EOPNOTSUPP, like for
BTRFS_SCRUB_SUPPORTED_FLAGS, BTRFS_SUBVOL_CREATE_ARGS_MASK or fallocate
modes. The EINVAL is supposed to be for a supported but invalid
values or combination of options. Fix that when checking send flags so
it's consistent with the rest.

CC: stable@vger.kernel.org # 4.14+
Link: https://lore.kernel.org/linux-btrfs/CAL3q7H5rryOLzp3EKq8RTbjMHMHeaJubfpsVLF6H4qJnKCUR1w@mail.gmail.com/
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/send.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -7558,7 +7558,7 @@ long btrfs_ioctl_send(struct file *mnt_f
 	}
 
 	if (arg->flags & ~BTRFS_SEND_FLAG_MASK) {
-		ret = -EINVAL;
+		ret = -EOPNOTSUPP;
 		goto out;
 	}
 


