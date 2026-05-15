Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8593B6354;
	Fri, 15 May 2026 16:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861366; cv=none; b=JWdbrmvVdSjqDQn9ePfwLWZUAlTy7eG41MdsPEhvKmfhNHB1pi6oc1SGkJtZiFYRXXlrVZVlezP8pzozdNwdCForpcZjOIfbEVC0N/IsORUZoEL5NT3xdIRkINq7MtgQjyRUUupxw+3Tid4OfD5jjKY3WS+9HsQ/hEjk6xlQXDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861366; c=relaxed/simple;
	bh=thFPF4eJatF7pu1eCA12910LGIwG4BIMRVLGBnVA61Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HL427w4vyqdoTfc8PH+amwU20zByNP/AyrJi9fHHjjBU+Kjx0nheYzC+APG8Ttjd+f34OyUiW+xLZXVYs5QfW2Ra3rfZWbB3UZsjy267RIJYLZ/0pTGgG4ZeSnVNf07BjQzeAVxSwSjBz3piTKxG/N8afuVR1YL9grlb96h3CVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oEMb0hvS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oEMb0hvS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02EA7C2BCB0;
	Fri, 15 May 2026 16:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861366;
	bh=thFPF4eJatF7pu1eCA12910LGIwG4BIMRVLGBnVA61Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oEMb0hvSN5PdsARlX6TwXnz13VwHoSgHgcmR7rzkHdDXzwK3VQQo6wsCahA2fw4Dy
	 gPhQ7Ngx8yXlqCbACK18ZXVDCOjtgPoqPdf3v2EcKe6p5M6QKe35k5v424x3rWSfdk
	 PjWDycLpaF2UUFU8xgWKyNP2FjLkTE5bjz5nypXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Soufiane Dani <soufianeda@tutanota.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.6 302/474] staging: media: atomisp: Disallow all private IOCTLs
Date: Fri, 15 May 2026 17:46:51 +0200
Message-ID: <20260515154721.539077324@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 2b7eb2c5dc72f0fc954ac4aa155f9e285e937f7c upstream.

Disallow all private IOCTLs. These aren't quite as safe as one could
assume of IOCTL handlers; disable them for now. Instead of removing the
code, return in the beginning of the function if cmd is non-zero in order
to keep static checkers happy.

Reported-by: Soufiane Dani <soufianeda@tutanota.com>
Closes: https://lore.kernel.org/linux-staging/20260210-atomisp-fix-v1-1-024429cbff31@tutanota.com/
Cc: stable@vger.kernel.org
Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Fixes: ad85094b293e ("Revert "media: staging: atomisp: Remove driver"")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/atomisp/pci/atomisp_ioctl.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/staging/media/atomisp/pci/atomisp_ioctl.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_ioctl.c
@@ -1780,6 +1780,10 @@ static long atomisp_vidioc_default(struc
 	struct atomisp_sub_device *asd = atomisp_to_video_pipe(vdev)->asd;
 	int err;
 
+	/* Disable all private IOCTLs for now! */
+	if (cmd)
+		return -EINVAL;
+
 	switch (cmd) {
 	case ATOMISP_IOC_S_SENSOR_RUNMODE:
 		if (IS_ISP2401)


