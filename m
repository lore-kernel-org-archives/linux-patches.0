Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361A241A766;
	Fri,  4 Sep 2026 05:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499826; cv=none; b=KpDlpFYK0lVadrGUbbM8pMXR6rWPyEm0on0YHjnn7pt1zq3RNhbCZwk+bRcbd4xHrJHk4XWNPoNk05RMH7AGFFwtkxb1c/iBBVJbzEqOPoTLXxq8c/NIqDYss+NRf+i5VErU6HRiWtcZRKisjzWKI3aFeaGG00Hvffl5iirNpAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499826; c=relaxed/simple;
	bh=3dU2a8hOJPjO5LGgjie/3NVbHf5NM43Q/joV1hmLXtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M2ZOs7yuYaP1jcxIyU3rjHAuAKVS5JEiAjrmSIsaCEoMbzXopHt5U7+wp7wlQNGDhs7fLIWzoxW/HqL+9i1le+CtWdIVdsbyzElRrac4XWM448dKlH0I5ITxmxP2o3eog0um6MR4JAzKJLULxQi2GN8DAITaDoxu1goONOCfASo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kn31vXBW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kn31vXBW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907F01F00A3E;
	Fri,  4 Sep 2026 05:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499825;
	bh=PTocUV73w1YAlqbsN2GEYUJiBpRdp8jcOZk0K9cQeSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kn31vXBWla6dxm2Iuyrp55RHrf4miOzSWx7t9TgFap9vLUC2d/b8KE2UhSHdi97ee
	 mkWWEBK3hbmD7/Kf9fuA/cG11GIfR2xk/gcYxwj6/SjWMxm6ZhPOvKAcCpY0cEUUA4
	 nfgaS6o81C0RZAYg3EVxb/r8Xudk19N9TS9B964g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 7.2 555/713] platform/x86: ISST: Add a NULL check for sst_inst[]
Date: Fri,  4 Sep 2026 06:58:43 +0200
Message-ID: <20260904045816.261388276@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 3de2776e9d7073765c10c2326c2bda5926811ea6 upstream.

To be consistent with other places, add a NULL check for failed socket
loading by checking isst_common.sst_inst[].

Fixes: d805456c712f ("platform/x86: ISST: Enumerate TPMI SST and create framework")
Cc: stable@vger.kernel.org
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20260811222134.3912626-3-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
@@ -1381,6 +1381,8 @@ static int isst_if_get_tpmi_instance_cou
 		return -EINVAL;
 
 	sst_inst = isst_common.sst_inst[tpmi_inst.socket_id];
+	if (!sst_inst)
+		return -EINVAL;
 
 	tpmi_inst.count = isst_instance_count(sst_inst);
 


