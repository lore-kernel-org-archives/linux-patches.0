Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF3C35AC03;
	Fri,  4 Sep 2026 05:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501462; cv=none; b=SoooqE1tIfwrdJBB+gGXFn17AWYOxMrT3RixaN+TB46/6MIDbwIFB8A0u4+SjdZ1cdAPP4/mxo6kJQBKa4C2Ee0w5MMRwmvT7K8ZkYqtVJPc0OcjxxR6quaqX1Lk1zGSa0fE9M1D58qdjSrtqzXRQwXycwUTRxWeOh0g4kx1wQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501462; c=relaxed/simple;
	bh=kL5Q36q6XzaLzhwHkMlVjm7vnZYkTbNPuVIAuyGT174=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TqKRTK8PzvhDVZ3/QiePHNMdU/PtrnZCi2kGGwTjcJBmkE82B7N6hMM5wsX0UhTOrHe2nXAbl6JH+qDuqFAEQ+hYIjeVYKieuXvCt9b6qdpkRmAfI3reJA/d5+bpw6DXIeuLZnOyo5o/WUlPr2RJxnlGAZtnZFIBJOidJ4GWsyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t+1iAzeM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t+1iAzeM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 627771F00A3D;
	Fri,  4 Sep 2026 05:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501460;
	bh=X1TfqIPqAEYIIdNxzIoYRPv8iDfC4+kkvARAN/2tYr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t+1iAzeM9mGUZmONdWKIhf7e+6xf2xDsRm5VKq3q0cu1iBThr9VwVRZekijDXiRtT
	 a9RY6U6C5lRmk4HnNeUJ8mrAKjcrM8kxNn1+KBul2uLcyNBNY3x0pWsSdAAa+3KnBV
	 mDLhcYpYFso3RX+aZhOb4WXxEp43QfWB2sN/Fy1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 418/552] platform/x86: ISST: Add a NULL check for sst_inst[]
Date: Fri,  4 Sep 2026 06:59:35 +0200
Message-ID: <20260904045800.089352890@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1380,6 +1380,8 @@ static int isst_if_get_tpmi_instance_cou
 		return -EINVAL;
 
 	sst_inst = isst_common.sst_inst[tpmi_inst.socket_id];
+	if (!sst_inst)
+		return -EINVAL;
 
 	tpmi_inst.count = isst_instance_count(sst_inst);
 


