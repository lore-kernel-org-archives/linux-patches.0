Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBAA5248BD0;
	Wed, 15 Jan 2025 10:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938666; cv=none; b=fsLN418b/A8t2DOTwLxsepV/IgO46Ay8tvekND/UUSY/ptFc78vZ0B5LjSw6L3/I6c++rcvAEmeAYiV39yJOYMFpVbrH1pJW3zKT6CgTGJCfveoMzzMgfu6C4IBX9rJVYC0JhSnqNaYYHFin/fGar5Ml+T14G33NNZYddtd1KvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938666; c=relaxed/simple;
	bh=Wvllju2buEf3o7fc93uHAPOy0eEOoGWNjDCRcEr355Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YJBaeas7NFRDR5sFhsPukhu98m1pE3x0bedlM0WOeDFcgNagBXOUzB4Dh56iPs0/WQ2qm+hk7I45EY38UdL0tjd4FyQCdBUtpGpT1hBC+cbHtsGFsC7uqTlZlIFbjU2JnE4rP8odzXKa9xXT7RW07OR3VRq8SrdBSypQCDeoblQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HZyMuIpS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HZyMuIpS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25800C4CEDF;
	Wed, 15 Jan 2025 10:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938666;
	bh=Wvllju2buEf3o7fc93uHAPOy0eEOoGWNjDCRcEr355Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HZyMuIpSdo0vzIY+RKN5lBjgDVddzYqJS+h/K4RxXf/3NfQnQeG0cyD4LssP7BvKy
	 FBRuumGz8c2rBMx4L6kOtqSMDtFFs5S5z2SFugjjVXm6RyhYibNjOEVrwjuDrwPz31
	 DcmUq4T9EYsLzI8N2OoijJ9ay+WYHF+SQcBbGzoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.6 060/129] dm-ebs: dont set the flag DM_TARGET_PASSES_INTEGRITY
Date: Wed, 15 Jan 2025 11:37:15 +0100
Message-ID: <20250115103556.774306371@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -442,7 +442,7 @@ static int ebs_iterate_devices(struct dm
 static struct target_type ebs_target = {
 	.name		 = "ebs",
 	.version	 = {1, 0, 1},
-	.features	 = DM_TARGET_PASSES_INTEGRITY,
+	.features	 = 0,
 	.module		 = THIS_MODULE,
 	.ctr		 = ebs_ctr,
 	.dtr		 = ebs_dtr,


