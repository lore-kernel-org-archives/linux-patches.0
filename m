Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062110;
	b=hF1el6nfOTmNq5/N7nqSRr0R2OmeMPqjfwxp78Pysqu1gJhE9d7AW/O9gUZ0VLLWcwdj
	 3WyRXX9WgNBzmDSARxbGPbojkQM0hurmnptGjyNxYlm5Cxyiy87sG8KLmWetV34Q0ArUA
	 gtXHC7J8Xs0HFsuaqP0ELCfAeGk5shzLN+lyekX1/DKrhIy+7IVwtVFwK4UOdwhrkGeq7
	 ueQaN76+LJ3Kiv4tmpde6pGXSdkaygrqzfHbkod20qz0j42q50kEgTsb0Ql6uu5rd/LgN
	 t/wdBSRVhpYhZF5lMqfkJQkO97ZENzcZo4lnpWjCpNo+vfHQUCpDvNfiDAsFJym8qbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6GA/U9OmlKEajtGFRHHZ82FaUZxQ0efKqnU9YhFmfPg=;
	b=yapQCxXb29qXQvFFr9SUWnPXYB30WxHHeO5MapUKyQkByhCkjchxqIQ52+0VKfgZdr+q
	 SLNedq/KlI9wbxQDwNjDmi5YNUV1JWWLvZaLxTVQ+yKT+qM8cAMg8ZwcazlXDaazojLQV
	 jqsF7ZN4aknxYaSx5V3CHbQ6TZQCMbk06LANv9mKGU/G7CTtBYHyuwAS0/ttVH/kwmIq0
	 ucHGDhea55+wDhVwoTeG/aTzsze5N99G9DxFkRAOf+/cMhETQxrrp0JKTqOPIaaT07+Zd
	 TGQMBUoNaylQP+WXBGLaO/eQVZ29RXez6UNo4hCdvBl6MJ/UmW5i8012R6wCpr0cKng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EAO9XcGZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2488660A3817;
	Sat,  7 Nov 2026 14:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EAO9XcGZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8291F008A3;
	Sat,  7 Nov 2026 14:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062109;
	bh=6GA/U9OmlKEajtGFRHHZ82FaUZxQ0efKqnU9YhFmfPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EAO9XcGZoc5wD6stnkWn4a07ENgnMygTq9cYZtupkWQD8oZg7ITFSYwNdIMLMdihz
	 bSclyB1DPkkzdjuN1ln3fQn+fAojwvLtkC1zwGDG0eL5zJ4p1cKd6Ry4r8FY58E67+
	 LAiLUzEeHwWWc14j6uWm9d6llMue5C5pMkLdMdOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1082/1536] arm64: dts: qcom: sdm845-xiaomi-beryllium: Extend the xbl_mem region
Date: Sat,  7 Nov 2026 08:51:38 -0500
Message-ID: <20261107135028.086808590@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Heidelberg <david@ixit.cz>

[ Upstream commit 511c4fea32708a065e03503c0e4d44f48990c530 ]

Xiaomi's Oreo-era tree still had the CAF 1 MiB region, the 2 MiB version
arrived with the Pie import. This isn't a board-layout quirk, it tracks
the firmware. The later XBL wants one extra MiB below the old region.

Cc: stable@vger.kernel.org
Fixes: 77809cf74a8c ("arm64: dts: qcom: Add support for Xiaomi Poco F1 (Beryllium)")
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260916-sdm845-xbl-mem-v1-1-6e3c88507997@ixit.cz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi
index c872d6442018d..93160543f2943 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi
@@ -26,6 +26,7 @@
 /delete-node/ &slpi_mem;
 /delete-node/ &spss_mem;
 /delete-node/ &rmtfs_mem;
+/delete-node/ &xbl_mem;
 
 / {
 	chassis-type = "handset";
@@ -54,6 +55,11 @@ key-vol-up {
 
 	/* Reserved memory changes from downstream */
 	reserved-memory {
+		xbl-mem@85d00000 {
+			reg = <0 0x85d00000 0 0x200000>;
+			no-map;
+		};
+
 		tz_mem: memory@86200000 {
 			reg = <0 0x86200000 0 0x4900000>;
 			no-map;
-- 
2.53.0



