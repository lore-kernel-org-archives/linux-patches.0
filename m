Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2838BE8;
	Tue, 30 Jul 2024 16:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357223; cv=none; b=rW5I9PQxw0rMucB73oF1vEWWebMYF1GdoOD9crHf2NVAmIGMlvIcvyngcS3iR3Rmm2BCtNtWCs0xIlkvYGHPkMQIK/ho/U7zz4rJyyk80B+YuS9IPPmU53pzeBKJ0TdpBKvXF9JJERnHhk6RSwRPxpvpxrx8K8uZX7ha1Ak7XJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357223; c=relaxed/simple;
	bh=3YSHMguzQGYKsTubLdw8933s1wuMJtPbKrHsUxaCsfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SUfFvhLFXtQW5rCY3gFYAocHhVtc1ctopQb79/X9WiyAQpdB9zs12QyhmIKa6kwjrvd4xaDpBwLtOSyaMP4nDlJiipUL5x0S/r8psRqAISe5ATrIomgUCrndyAb8yTCD3av14QkxCShWWhZFOxdrYLFU/aNAnjASwEvoGSAkfnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K6/jfG4m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K6/jfG4m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC5EC32782;
	Tue, 30 Jul 2024 16:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357222;
	bh=3YSHMguzQGYKsTubLdw8933s1wuMJtPbKrHsUxaCsfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K6/jfG4muwqbdm314w6I95b7sH2+djjm9M/8V0Oqu/f1041rnPffrNDFuFOEzPYrB
	 imT2VMSN+8At1xH+sQXLmxrHO3Jq2sObs+cGXeJkEkNHcIXxY7ZpMAMiLW0GCvpHuY
	 gO/HBO+AgO2a7gqRUSNa4JU79JCUvIJVLY8PZsf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 234/809] NFSD: Fix nfsdcld warning
Date: Tue, 30 Jul 2024 17:41:50 +0200
Message-ID: <20240730151733.849096565@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 18a5450684c312e98eb2253f0acf88b3f780af20 ]

Since CONFIG_NFSD_LEGACY_CLIENT_TRACKING is a new config option, its
initial default setting should have been Y (if we are to follow the
common practice of "default Y, wait, default N, wait, remove code").

Paul also suggested adding a clearer remedy action to the warning
message.

Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Message-Id: <d2ab4ee7-ba0f-44ac-b921-90c8fa5a04d2@molgen.mpg.de>
Fixes: 74fd48739d04 ("nfsd: new Kconfig option for legacy client tracking")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/Kconfig       | 2 +-
 fs/nfsd/nfs4recover.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/Kconfig b/fs/nfsd/Kconfig
index 272ab8d5c4d76..ec2ab6429e00b 100644
--- a/fs/nfsd/Kconfig
+++ b/fs/nfsd/Kconfig
@@ -162,7 +162,7 @@ config NFSD_V4_SECURITY_LABEL
 config NFSD_LEGACY_CLIENT_TRACKING
 	bool "Support legacy NFSv4 client tracking methods (DEPRECATED)"
 	depends on NFSD_V4
-	default n
+	default y
 	help
 	  The NFSv4 server needs to store a small amount of information on
 	  stable storage in order to handle state recovery after reboot. Most
diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index 2c060e0b16048..67d8673a9391c 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -2086,8 +2086,8 @@ nfsd4_client_tracking_init(struct net *net)
 	status = nn->client_tracking_ops->init(net);
 out:
 	if (status) {
-		printk(KERN_WARNING "NFSD: Unable to initialize client "
-				    "recovery tracking! (%d)\n", status);
+		pr_warn("NFSD: Unable to initialize client recovery tracking! (%d)\n", status);
+		pr_warn("NFSD: Is nfsdcld running? If not, enable CONFIG_NFSD_LEGACY_CLIENT_TRACKING.\n");
 		nn->client_tracking_ops = NULL;
 	}
 	return status;
-- 
2.43.0



