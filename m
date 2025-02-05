Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A7115CD74;
	Wed,  5 Feb 2025 15:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768500; cv=none; b=hhc+VPQpz4VSyQXOaV8SH/SCug+d8OmPmwXfXM0cNUaZdCia6x/1c+VQVlfAt8N2XXoNmMMAWCaxXV1lGNcyjm5MqDmq8AycA0c/47CzSx/6CRfqyj6oF8k4BaoGQwCWngAM9iwy3S/GuEC0vOQoeA+ziSZPggTZueYN/8JHux0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768500; c=relaxed/simple;
	bh=PUJrOE+OSnWHTys26T+z0Uq+/2UjZZ+0Dg7ffFQaDtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oVdKXXtMRzbAcvJ5W5prKBVF92uGG/l6oYI0AcBhPDV2Xcm2LtQfY7cU+TX2fDkFCc26IoRktmnLAAFkTdTEF7SMNE96nGRZNJOSxlmhw+L3ey8BhFEqsdiEF+gY2aR4N8rB/crauEDtBGy5NoEY8Gqo7mDIMQ0wDY4IAlGoSFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mj9QC2oG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mj9QC2oG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12466C4CED1;
	Wed,  5 Feb 2025 15:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768500;
	bh=PUJrOE+OSnWHTys26T+z0Uq+/2UjZZ+0Dg7ffFQaDtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mj9QC2oGVS4WjzW7s4Eg0rFAcxX14yI4ID0LTqIt25IiwHrDXHmuJbsplNWWSJzCh
	 1I5ta6nkt1hKOg1j4BK2bdiTzT/V7zXiL7tT3Rk7k6vv/MMOd3e/Wm+K7bhloFJldS
	 aJOeIlGR0tgcMu09kYosFftxEYeUHHfKMxFhHxEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Xiao Ni <xni@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH 6.13 575/623] md: add a new callback pers->bitmap_sector()
Date: Wed,  5 Feb 2025 14:45:17 +0100
Message-ID: <20250205134518.219655594@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

commit 0c984a283a3ea3f10bebecd6c57c1d41b2e4f518 upstream.

This callback will be used in raid5 to convert io ranges from array to
bitmap.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
Link: https://lore.kernel.org/r/20250109015145.158868-4-yukuai1@huaweicloud.com
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Yu Kuai <yukuai1@huaweicloud.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -746,6 +746,9 @@ struct md_personality
 	void *(*takeover) (struct mddev *mddev);
 	/* Changes the consistency policy of an active array. */
 	int (*change_consistency_policy)(struct mddev *mddev, const char *buf);
+	/* convert io ranges from array to bitmap */
+	void (*bitmap_sector)(struct mddev *mddev, sector_t *offset,
+			      unsigned long *sectors);
 };
 
 struct md_sysfs_entry {


