Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731BD33ADB8;
	Fri,  9 Jan 2026 11:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959939; cv=none; b=LSC4gj4i5HAGenInhOiPZ7lMe9hPbTY/nR8SK+bhdQ2VEwHkau4naFYxVTQuwrGZK5zND2zRzJjECyO/QAbs/wxvnCF76qhw6x76vX3RQyDyBxXa95D91oY5qf239xzU0Y0JGAbwIEfB+pdULt41bJ27GoezL/SC2yPeZBJbR0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959939; c=relaxed/simple;
	bh=D/3tuzyYiAH+sxDlGdwSGdNhjC8xoEn8YAcZeD2U218=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QufM6U5T5eJXHioRUUDFiHUHwE8QV1Axb1A2Q+H6eVSyNa7Il5Q39LFkKc0HLmVw7CBosAuhMUxFS4l4RpWNOlqlazhf9TSW1+QBSiT0h3TbNXVzcHNCvaUUn2bOD5x3MWOB9pPSPguYJjligJMkOmHGPsU2ctFjWSaLqAOZ0r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lgE9Tm24; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lgE9Tm24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF843C4CEF1;
	Fri,  9 Jan 2026 11:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959939;
	bh=D/3tuzyYiAH+sxDlGdwSGdNhjC8xoEn8YAcZeD2U218=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lgE9Tm24K4N+jdyC2Vww0SeQUfD3TxK7mjuRatd9HpsPEcnNsI1jx/eh3hA4oZUJz
	 YW+XxGemdkLiAFENn4MwIonsGrhs5vZ0Nj2H/05Zoe1Hzq3QDfZzXehPJcJw8K6x/Z
	 if5B61ASODmgXurElbDrt74CaqMUoHojqq08/UxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Brett Creeley <brett.creeley@amd.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 229/737] vdpa/pds: use %pe for ERR_PTR() in event handler registration
Date: Fri,  9 Jan 2026 12:36:08 +0100
Message-ID: <20260109112142.614426387@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 25c0fe5ec3d5d..744739a708b25 100644
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



