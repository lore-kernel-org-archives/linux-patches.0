Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A10536657B;
	Tue, 16 Dec 2025 12:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888221; cv=none; b=itdXsAFGRnGUHkoWxeir2S8JymHQtOfUZIJi0kgT74VTvt6nCJnagt/1XcRVHF7McEcR4s/SpcbW5yhpB6eNNEa/WS/imTQV5R8kJ175uSfKvxKkD5q36TL2QJWc1NA/GnVe1FXAkyEsbHWELsUUV/2lF1rcs+2PsVMP0SLl/tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888221; c=relaxed/simple;
	bh=RwLje93PjaJHijdGuduPiFxiC3wdyAbNCRO3A6MKoeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJ3/YkYEo9ZFciE21VgxvjO+AG4QIwLkDqBcbjMRpdPcGYWIhm13KzvA4TPSQyIk1PC4LUMONoyEC+u3SqJod2LErkA9T6DHav5nVL3hET6/J8GaQsY36tJtlA5GLdDfeIW56rl7csjVnDJN5r4Usk+zj30uH/43I2nFqE9YcXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bcNfaLMk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bcNfaLMk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7282AC4CEF1;
	Tue, 16 Dec 2025 12:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888220;
	bh=RwLje93PjaJHijdGuduPiFxiC3wdyAbNCRO3A6MKoeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bcNfaLMkJMAD0Yef5sBUxDGuQEGG1zKT/inV+HmTY6KuVBcXUhBWVdS7cRf2+iBGz
	 4/M/EUvU5OwBT58Qz7dg/yjY59LtXHDjb3fleuyExPzkas6Vp4YoWr2vhuL4Vee52A
	 X1g39JCMP9tPe/rT144AWcdID8IGqHYuIEpy8YV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Brett Creeley <brett.creeley@amd.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 469/614] vdpa/pds: use %pe for ERR_PTR() in event handler registration
Date: Tue, 16 Dec 2025 12:13:56 +0100
Message-ID: <20251216111418.363457587@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 731ca4a4cc52fd5c5ae309edcfd2d7e54ece3321 ]

Use %pe instead of %ps when printing ERR_PTR() values. %ps is intended
for string pointers, while %pe correctly prints symbolic error names
for error pointers returned via ERR_PTR().
This shows the returned error value more clearly.

Fixes: 67f27b8b3a34 ("pds_vdpa: subscribe to the pds_core events")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-Id: <20251018174705.1511982-1-alok.a.tiwari@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/pds/vdpa_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vdpa/pds/vdpa_dev.c b/drivers/vdpa/pds/vdpa_dev.c
index 36f61cc96e211..43426bd971acc 100644
--- a/drivers/vdpa/pds/vdpa_dev.c
+++ b/drivers/vdpa/pds/vdpa_dev.c
@@ -51,7 +51,7 @@ static int pds_vdpa_register_event_handler(struct pds_vdpa_device *pdsv)
 		err = pdsc_register_notify(nb);
 		if (err) {
 			nb->notifier_call = NULL;
-			dev_err(dev, "failed to register pds event handler: %ps\n",
+			dev_err(dev, "failed to register pds event handler: %pe\n",
 				ERR_PTR(err));
 			return -EINVAL;
 		}
-- 
2.51.0



