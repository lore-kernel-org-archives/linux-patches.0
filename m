Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C033F1DDCE;
	Tue, 16 Jul 2024 15:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145262; cv=none; b=QD+HbJZIqXlYACvR4YbwZfE5VEovBPK9N/WamU0dV7uqNepZq7AqZJwAo+m2bzN9Ho0TMjbO+GczMO5tXSiXlu5hyBD3XHau9l8CTcpn9wLdrAe4qP1yYN3P+3OKy4CtErXNG6H4se9CfQd7AKAF5hhJwSKBtXerWUp2nJ5BX7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145262; c=relaxed/simple;
	bh=hEeTJeHBrxRY72J9PP3tUrETWBiWXimA9josrpCYSAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTKsgNukYxZj6uOrsFRHL0JRBCnXTnK908yyDsP/+9qOBvDYK+0TTl51FzZq5nsoqkhateIa9u9Ys4R1/d5P9wxEMxItqyqg75CEtaBJaiaynT9T7pnkEj8Zj97iqItLawneiFfl2BVbkGiTnwipzUUhb5PDNgMWc8fx6Zzo8HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2bWE4bed; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2bWE4bed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47FA8C4AF0B;
	Tue, 16 Jul 2024 15:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145262;
	bh=hEeTJeHBrxRY72J9PP3tUrETWBiWXimA9josrpCYSAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2bWE4bedx9k8pc2LPo9uQusCwT2DwqmfyotqrD+UwCJ474RkTpq6o5l/OW7bPGZNB
	 bIiGNxNWZ8EPIkGGWsoaVRhzS5WXo6bLYWdNHHo90bVbpkS03CmydeYmUHeZ8EVPNR
	 qv5Ykf1NpnEmt/pd5u86uge7m2piMQgIP/5ZARiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ekansh Gupta <quic_ekangupt@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Caleb Connolly <caleb.connolly@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.9 124/143] misc: fastrpc: Fix DSP capabilities request
Date: Tue, 16 Jul 2024 17:32:00 +0200
Message-ID: <20240716152800.756513562@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ekansh Gupta <quic_ekangupt@quicinc.com>

commit 4cb7915f0a35e2fcc4be60b912c4be35cd830957 upstream.

The DSP capability request call expects 2 arguments. First is the
information about the total number of attributes to be copied from
DSP and second is the information about the buffer where the DSP
needs to copy the information. The current design is passing the
information about the size to be copied from DSP which would be
considered as a bad argument to the call by DSP causing a failure
suggesting the same. The second argument carries the information
about the buffer where the DSP needs to copy the capability
information and the size to be copied. As the first entry of
capability attribute is getting skipped, same should also be
considered while sending the information to DSP. Add changes to
pass proper arguments to DSP.

Fixes: 6c16fd8bdd40 ("misc: fastrpc: Add support to get DSP capabilities")
Cc: stable <stable@kernel.org>
Signed-off-by: Ekansh Gupta <quic_ekangupt@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Caleb Connolly <caleb.connolly@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20240628114501.14310-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1693,14 +1693,19 @@ static int fastrpc_get_info_from_dsp(str
 {
 	struct fastrpc_invoke_args args[2] = { 0 };
 
-	/* Capability filled in userspace */
+	/*
+	 * Capability filled in userspace. This carries the information
+	 * about the remoteproc support which is fetched from the remoteproc
+	 * sysfs node by userspace.
+	 */
 	dsp_attr_buf[0] = 0;
+	dsp_attr_buf_len -= 1;
 
 	args[0].ptr = (u64)(uintptr_t)&dsp_attr_buf_len;
 	args[0].length = sizeof(dsp_attr_buf_len);
 	args[0].fd = -1;
 	args[1].ptr = (u64)(uintptr_t)&dsp_attr_buf[1];
-	args[1].length = dsp_attr_buf_len;
+	args[1].length = dsp_attr_buf_len * sizeof(u32);
 	args[1].fd = -1;
 	fl->pd = USER_PD;
 
@@ -1730,7 +1735,7 @@ static int fastrpc_get_info_from_kernel(
 	if (!dsp_attributes)
 		return -ENOMEM;
 
-	err = fastrpc_get_info_from_dsp(fl, dsp_attributes, FASTRPC_MAX_DSP_ATTRIBUTES_LEN);
+	err = fastrpc_get_info_from_dsp(fl, dsp_attributes, FASTRPC_MAX_DSP_ATTRIBUTES);
 	if (err == DSP_UNSUPPORTED_API) {
 		dev_info(&cctx->rpdev->dev,
 			 "Warning: DSP capabilities not supported on domain: %d\n", domain);


