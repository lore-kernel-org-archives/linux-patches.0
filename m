Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49A8242910;
	Fri,  4 Sep 2026 06:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501656; cv=none; b=XYD3aYp0TpdvhRjToYYV6knRNIkpGp+paOgI/YHZAEpm8gCLvad1j6SkQp4MUA7QK1IatoqsA2qymHSbd/kEnhYoCXa4STnivr+y8A23vNhhZhIkjb4/bil/BETcG0DpTEeNnfVIEbXiDrMSTdqVAt4tlO50uGIzN0nq42HSTNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501656; c=relaxed/simple;
	bh=S5yitIdOHTnG6QphFP7Dd08bgtOpw85g/o4Wt2GsRrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ateeVAUIhS9CP5XOD2i7V9TakYKsf3E/RSN1gXK0CVV0izgzACxXXrIJ/NAXAVxeEe02uC1dqYcqzctb4YF0mpJTdz1QPbrfgWJRXoPVUufQyZlLfNqAbpM4DkVBPvUOa0YOWQl74CL7/attxVjOU+PjuQHmeQCIMXeF0dMpfWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eEsPzzBN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eEsPzzBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A5D1F00A3D;
	Fri,  4 Sep 2026 06:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501655;
	bh=KLACzb0Kb9PVMOkCiB0N+geqblKQwVWuref4VqJaQaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eEsPzzBN51LM/G67ehHZhPYl5PJVQuBl7zEzOWCiNKLF/beb27pXexVrsYZbuJQAr
	 J2q5vUiwYogSs5jWDZsVbJ76xFBrOkYzko/pj1BpaYJcXp5UMHY5rAMwdjkne26UHS
	 yud3fbkUC83dDBaMmYwW/xNdbWp9/nIWWt8ISxn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Thomas Richard <thomas.richard@bootlin.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.18 484/552] mfd: cgbc: Fix teardown ordering in cgbc_remove()
Date: Fri,  4 Sep 2026 07:00:41 +0200
Message-ID: <20260904045801.643064063@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richard <thomas.richard@bootlin.com>

commit 2970c2db8ab3d97ea6250c14ca49b1e1731115ab upstream.

Release Board Controller session once children are removed by the core.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/cover.1783507945.git.u.kleine-koenig%40baylibre.com?part=19
Fixes: 6f1067cfbee7 ("mfd: Add Congatec Board Controller driver")
Signed-off-by: Thomas Richard <thomas.richard@bootlin.com>
Link: https://patch.msgid.link/20260713-cgbc-core-fix-cgbc-remove-v1-1-79274ad62b3a@bootlin.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/cgbc-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mfd/cgbc-core.c
+++ b/drivers/mfd/cgbc-core.c
@@ -363,9 +363,9 @@ static void cgbc_remove(struct platform_
 {
 	struct cgbc_device_data *cgbc = platform_get_drvdata(pdev);
 
-	cgbc_session_release(cgbc);
-
 	mfd_remove_devices(&pdev->dev);
+
+	cgbc_session_release(cgbc);
 }
 
 static struct platform_driver cgbc_driver = {


