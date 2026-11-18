Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060299;
	b=XlM3CXvSx5mu8Iu01UBkro3Lnjnj4VlKYu0iyPBDdL4q26esSD/M2oEpA2RK3+UQP0AZ
	 APPJFQhPJ5rWWcxWKqV29RjghJsSzHcDZgMBary4FssTNx170SIkN3cZ55rwZYfZ6EO8a
	 p38TNNj+3SkdBZr0gPZaGZKSdd+bPsCPoapnkAC8pFRLyxHOKl7bJFTZJaQpFyPMMpLmC
	 Ni/GsOrveYYx/pLbhLPQKISaCDv01a/ZzlwtCV7T968UiBkcB2aBVn/ldH0L5nWs77iR7
	 NWEigwmLHXkZ4DVkIQ97lRqEEWJek+GVWpQpfm7c9Hk583okKVDq42iaBirbHgoprzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060299;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GjQ/Ki/GP4y2VhhDaocScTUomj9xdYechvjh9sb196k=;
	b=k4XFZyeeT6YUACyvvOy0vqP4K5Xcx+IQmTT4gUq/mxNJnBJzhRk6f00S2TzL1okfVrlH
	 HddwSk+wh5ti4Zth8wFVpZI/SY8B8XG+BggsDkDDM/T2+MUMWzCcEyuMsrQJMARAivFQu
	 CLf7i4muCYCesPhF+PUspocoV0f6XGzCjJYWwo6jE3VGpyBV9xIiUe21nHlMs0yFj8Xxc
	 iWYe/BTpiptP1Pg0w0kaTArIGj+UVU/3WEVu64aYgTB8BDS3Pdu72v9XmVU8lOoDm8qsR
	 44VpUncE/pNZE9xwUQT2Rt1n/gVxG6MiZg+TN7KxYuSu7hfmcz8tgavXcRCeV+Jnssg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DD3GAExe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2039B606A320;
	Thu, 19 Nov 2026 03:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DD3GAExe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716BF1F000C4;
	Thu, 19 Nov 2026 03:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060299;
	bh=GjQ/Ki/GP4y2VhhDaocScTUomj9xdYechvjh9sb196k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DD3GAExeILxZLM9ZBh5JdvCohZ3Q42lkySbJAOPPyvGSUdLUtPqoXR6ymGXu1uYNF
	 QS33t4I3R+yT0Bp6cih1aL/DUuy0OaQ1XNGqxOUIWcWDnxdQr1N1f2sUHxHaC0t+OP
	 fADGN2TtWrt0zbCiWoPFNZgN8bWr/ZpuXaPwJN4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1147/1848] remoteproc: qcom_q6v5_adsp: Fix double jiffies conversion in adsp_start()
Date: Wed, 18 Nov 2026 15:53:05 +0100
Message-ID: <20261118150007.766931330@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>

[ Upstream commit f559ef6316971fe39dc5f5edd6a483429ba03768 ]

adsp_start() computes 5 * HZ, an already-converted jiffies count, and
passes it into msecs_to_jiffies(), which expects milliseconds --
reinterpreting the value and shrinking the intended timeout. Every
other caller (q6v5_start() in qcom_q6v5_mss.c, qcom_pas_start() in
qcom_q6v5_pas.c) passes msecs_to_jiffies(5000) directly, matching
qcom_q6v5_wait_for_start()'s kerneldoc, which documents @timeout as
already being in jiffies.

On CONFIG_HZ=250 this shrinks the intended 5 second timeout to
~1.25 seconds, causing a DSP that legitimately takes 2-3 seconds to
signal ready to be spuriously torn down as a boot failure.

Fix by passing msecs_to_jiffies(5000) directly, matching every other
caller.

Signed-off-by: Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>
Fixes: dc160e449122 ("remoteproc: qcom: Introduce Non-PAS ADSP PIL driver")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260831-b4-adsp_start_jiffies_fix_upstream-v1-1-9f8cf85ea220@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_adsp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/qcom_q6v5_adsp.c b/drivers/remoteproc/qcom_q6v5_adsp.c
index c39138d39cf07..03f258d9c23a8 100644
--- a/drivers/remoteproc/qcom_q6v5_adsp.c
+++ b/drivers/remoteproc/qcom_q6v5_adsp.c
@@ -230,7 +230,7 @@ static int adsp_start(struct rproc *rproc)
 		goto disable_adsp_clks;
 	}
 
-	ret = qcom_q6v5_wait_for_start(&adsp->q6v5, msecs_to_jiffies(5 * HZ));
+	ret = qcom_q6v5_wait_for_start(&adsp->q6v5, msecs_to_jiffies(5000));
 	if (ret == -ETIMEDOUT) {
 		dev_err(adsp->dev, "start timed out\n");
 		goto disable_adsp_clks;
-- 
2.53.0



