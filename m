Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E6476C9C;
	Tue, 20 Feb 2024 21:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463383; cv=none; b=LVU+w3lfa/pkaV2CBdJI/yxJOIf+TM7mIXlPAq1ImdmilsM43ynLqkZAduYIBFb6zierKvq3jp+8MOpI0SH7OzhNdfYcRzzh5k8Erp6U23ckX4PR9peLmrJw6opawe7moeLIkaSHPLQAFdxyu9oe9pHy9N6xd+x14QT/zt1P19E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463383; c=relaxed/simple;
	bh=ToPUSLYTswToS15IRkwCag5aJ1mrEBNgctbzc9ragwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A1yh9p6jpY384ncX0eskHavgNf8fCpcwlnxDcbDsoPHqZLFWR7alasJb2YofHOYawI1C4474verYPpV1X63t7JsXE4Xh8bpIaJPwohNfaWVUh1kqDt5+JRLYYNmhpnVJ7zunaRTa8pylNVYd+jH1gU9S/Gx2p6kpnMpkifF0Mwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zQX/AvAZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zQX/AvAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D59C433C7;
	Tue, 20 Feb 2024 21:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463382;
	bh=ToPUSLYTswToS15IRkwCag5aJ1mrEBNgctbzc9ragwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zQX/AvAZADZFiIyjf18m8oIZOCx7/FvYh34jEZ544U7jPAiciSUUFrtS+x+bjNKsb
	 JvbV2W7s3gTwQEgnoZ1H/8DmjyWqPBZaHk1AJr99yzth3/3kiqbyiyCWbICdFvNkYk
	 qHsQI4WqwfgVFfG2lfH+V1xYyguix3mJ/eGIsN6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 008/331] btrfs: send: return EOPNOTSUPP on unknown flags
Date: Tue, 20 Feb 2024 21:52:04 +0100
Message-ID: <20240220205637.848937303@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -8111,7 +8111,7 @@ long btrfs_ioctl_send(struct inode *inod
 	}
 
 	if (arg->flags & ~BTRFS_SEND_FLAG_MASK) {
-		ret = -EINVAL;
+		ret = -EOPNOTSUPP;
 		goto out;
 	}
 


