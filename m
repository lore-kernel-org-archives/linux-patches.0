Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D73D1E990E;
	Wed, 15 Jan 2025 10:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937632; cv=none; b=TKUDlvrJBbXuJ5cR2+6+e7mBHLAuy2A5dYbrlcjPShUOtexvwiKIYn1QOIse7j2AUYUAzBOAVHFCGrvZAhDlSH3sV1b2LhImZa01rm5xYWmMpJ59IBqbWWYfp7eCPwKmGKVEsYxaT4XIO4myGVuX5YBY/tRy0coFUCoMxbyyJUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937632; c=relaxed/simple;
	bh=JZzzSbgwQ5GzL9ZHypGyB0tyM9AsWQq/lgjcrj8LnfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aSoYhufg0isrt2cfRnIhxoOvRjsRvqGxzTKqVaM3Oe8eIhHYQiHTxGfsqkJ7huEDVfIIEJP1MqsHcLtN3LzPPl6j8Uqtz9k0otmE4vlv9Q8sG2WqMOPjwHGKjZM2ei4/yN0NRcpAmWSdjsYFWQ2IvCDd/+uTJBLqSlApIJidpgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y1tookXX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y1tookXX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48928C4CEE1;
	Wed, 15 Jan 2025 10:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937631;
	bh=JZzzSbgwQ5GzL9ZHypGyB0tyM9AsWQq/lgjcrj8LnfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y1tookXXhwqerIFHM6HsJQis9a+iD+zy2dlal7zHrtl5JS91wlRR87GdeW2Bwm99l
	 wmywZR9qqqEbNjVccp9iF45Q7xJF9gJ6Kl4ZiYUuEAVPqSMe40SH7wOMtNge6Ii2MG
	 lhcfaRGpbZ5olgPEnaMkeNVOi6Xx6ahM7q6hnQak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 37/92] dm-ebs: dont set the flag DM_TARGET_PASSES_INTEGRITY
Date: Wed, 15 Jan 2025 11:36:55 +0100
Message-ID: <20250115103549.010366888@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 47f33c27fc9565fb0bc7dfb76be08d445cd3d236 upstream.

dm-ebs uses dm-bufio to process requests that are not aligned on logical
sector size. dm-bufio doesn't support passing integrity data (and it is
unclear how should it do it), so we shouldn't set the
DM_TARGET_PASSES_INTEGRITY flag.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Fixes: d3c7b35c20d6 ("dm: add emulated block size target")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ebs-target.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-ebs-target.c
+++ b/drivers/md/dm-ebs-target.c
@@ -441,7 +441,7 @@ static int ebs_iterate_devices(struct dm
 static struct target_type ebs_target = {
 	.name		 = "ebs",
 	.version	 = {1, 0, 1},
-	.features	 = DM_TARGET_PASSES_INTEGRITY,
+	.features	 = 0,
 	.module		 = THIS_MODULE,
 	.ctr		 = ebs_ctr,
 	.dtr		 = ebs_dtr,


