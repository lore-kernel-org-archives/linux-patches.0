Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E4D248BA1;
	Wed, 15 Jan 2025 10:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938129; cv=none; b=NINXdahDbl+cYpr76P1/eqSuqYgDZPzTtM7GdNJKbKTCFpEOqkr+vhUlH5oTyG1xVuNPdljsS9kjE14HEGPSbhoGKoZoIRJcQuN0UvmiwEQgi1+htdWtlmFocfyMBDgHnQ8qTwYTvwSJkl5WDKAEkgsXiAGsfKpPCamzdeEOY3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938129; c=relaxed/simple;
	bh=JXDLr60kmayfrieDKsad5JUSXh89d30zUdHfxVeZvmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JzO+9Ub1jrh0UT81FKw8y9I634BnGakn38iEvkpB2NXW6AjpkuOVph2iWY07Sh1ggcE9RqsUmmAUdRsokkrG0FO6iKXX35Ml4ksV5L/YBTX3zPStLUk829+bbdFHMBiQSesox9iESS6K2A0aouGH3E+EfRFxxFHasmKaro/O2OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VhERudKY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VhERudKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0EF3C4CEE1;
	Wed, 15 Jan 2025 10:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938129;
	bh=JXDLr60kmayfrieDKsad5JUSXh89d30zUdHfxVeZvmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VhERudKY0SLNWz8XDUHcVohLXf0l+A8Y3HG62+JVk7Sr+XBaXnDYpoVUsGGVCIO2P
	 Xb2Af2wlN79zpC5DSz4WdbfcXfpKpxWCt5KMSbRgBU5+r9JFCgpb8zZDMEIFzn3qVK
	 ++QCUk5jP3TZEWay1kecUwmVq251VzdOzRHKvN1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 090/189] dm-ebs: dont set the flag DM_TARGET_PASSES_INTEGRITY
Date: Wed, 15 Jan 2025 11:36:26 +0100
Message-ID: <20250115103609.922886744@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


