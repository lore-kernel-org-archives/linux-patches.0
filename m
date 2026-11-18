Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019851;
	b=nUh6FPUhGSPNKZntcG8lGqIT1r+oR5I31xBHdHxyCzV755HfNMcVLVcXKXjIcDosgmPy
	 aXwxVnKjoHyAV59VKlOcjiZ0wTFOYAeLW5VJU9+/ELsHJaaX1i7sfXH+ls/0YoV4iEGAf
	 Y/2b54QS8c0ZTkp5lcEwO+9Dv3I5CKqj4/XXDqOtJXnMYI226jtLAyfW5JvxL2Z/AN9GP
	 wN6HZBxrfLXG2Q2PTBdbO3uF+Y1mQR3aAkkAj2LN+KVBdgPguFCVxrCet4aay7PU9trl/
	 LOWNHvTL4UTzk91tIvHt3RoZznwmRYOztL0pTOypZvpu177EYR2+PrvE/FdW9VYehPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019851;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AMv3UYMI3utOSvelxqDAKnIri9E6kwfrOsLPrVSYRsQ=;
	b=xZCsNYmQbuomMWQikypIJmxeh6jZ3J3j3xYa6Z3CrVksAbwx7FD0t3bDg6JfPneu7FuJ
	 O1bTRdIiQnqzn2XG5lkztKJNqzUphae9EKVKVhDRzzssvOu+dN6J3ylKVPTP2ILikhjXj
	 tXzRn3TH0uocf0FBJd+tYL18NfcD6/scFhX+C+kh/88adP5KUCE2VK0qZ9GNsFhEvd/Fi
	 e0wwsindzlgHCnd9QHGfXBmh/tRwBhX5hAfBlS0v9/DcW4CP3l+Gjj18JSOWBPRAdUdZK
	 IMY0z4Fap1mTIPZbXUfH8TopcEPoifAHKlLfz813TkXAe05/Z/qmUB4tSyKK9FAD9SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0tJFBVNh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E2460A2608;
	Wed, 18 Nov 2026 16:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0tJFBVNh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 650D51F000C4;
	Wed, 18 Nov 2026 16:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019850;
	bh=AMv3UYMI3utOSvelxqDAKnIri9E6kwfrOsLPrVSYRsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0tJFBVNhnO0CDDNdUVMA/45SExtg6ucsQ7HV0lWV2r2lJacQ/3KEOwC+N6QTHbx16
	 pm3IZDjfXBv5/3nH1UYNZlyQRM42WK/+gYqS0Gvz+X7uoT0PFlsL/Hg8orthtz+yXX
	 WRBzdVTdLTmkbTJ30awJutGVRyO0i/yGdXLwohfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1741/2651] clk: qcom: gcc-kaanapali: Tie the CX power domain to controller
Date: Wed, 18 Nov 2026 15:49:41 +0100
Message-ID: <20261118150350.242319706@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit b080163dce8ce06167fa7c88eaefd4282955f616 ]

Enable runtime PM for the controller, allowing CX to be powered down
once all GCC consumers have released their clocks and GDSCs.

Fixes: d1919c375f21 ("clk: qcom: Add support for Global clock controller on Kaanapali")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260924-qcom-tie-cx-to-gcc-v5-15-38732033e5b5@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-kaanapali.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/gcc-kaanapali.c b/drivers/clk/qcom/gcc-kaanapali.c
index 5bcbcd1786577..c40d2da1086aa 100644
--- a/drivers/clk/qcom/gcc-kaanapali.c
+++ b/drivers/clk/qcom/gcc-kaanapali.c
@@ -3502,6 +3502,7 @@ static const struct qcom_cc_desc gcc_kaanapali_desc = {
 	.num_resets = ARRAY_SIZE(gcc_kaanapali_resets),
 	.gdscs = gcc_kaanapali_gdscs,
 	.num_gdscs = ARRAY_SIZE(gcc_kaanapali_gdscs),
+	.use_rpm = true,
 	.driver_data = &gcc_kaanapali_driver_data,
 };
 
-- 
2.53.0



