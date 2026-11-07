Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062332;
	b=hGRXRD0sBdD7grXsNg95dL7HxmgG2Zbi6T776iD4G/EfXC24AGQ96dsDQCYETzfOzCGH
	 G7jercUXgIGSSRa4ep1R4HbYVJQppaKL5i6i4L5rz47gKM/7MPFcwGHNlCoa5v+naaee/
	 pTdc/CAOc4yJb9zhhkVXhQA6iQx07TLJ9Pyi3O/MsZEqtkklYo1H8WosZW/ihisn0dA5o
	 YugPVJpHrCXNHXLAX+KUQYWQsE8xhuJTX7XOVa/45nLTWC9CKJwQh/veLsgaJdyd37DyX
	 5w8BqGJtfzv4iylihtKUqjAfIOI0F56mBeFKKsUVN3NNblM91uvS37trAJ/d6liViPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062332;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OachTx0qRmzxcR1vi1eVRIcXzhzuDsyqlEQCemhE3zE=;
	b=zha5ZI0MOMp291Jc20T25NmFRQ7udwxG9mtTAsqAJavJCZex8qzgsEkgMsxzSmfrnJY6
	 uIUM1ro4lGv3AJI5NywI5PrmBDBVvVCwFkthNHwZvVlPjBsW91OBbPgnuSVpsAXwbmke+
	 N8gaRYpuIQFvd6UxrMudSWGnruOmXbYm/ZDqCQjHjuinjdiYKS1b1T2ocGWj/1fSREADj
	 ak8nwrV9RncvV8+THxi1cj4AIjWpMZVgSX4DBkbULeF58EebDeIUEaf+KPkeQXTx8g6XB
	 k3ykj2taqYbByDoJFEr0aZnWQ8iVOzsVdAVSDNP1ycS18gE3+TzFz1q0L7F4eHD3UOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="S/P1mIwr";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AA7606A32F;
	Sat,  7 Nov 2026 14:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S/P1mIwr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F481F0089F;
	Sat,  7 Nov 2026 14:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062332;
	bh=OachTx0qRmzxcR1vi1eVRIcXzhzuDsyqlEQCemhE3zE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S/P1mIwrDgs1ddfWk/EVNI8J6Q7+U5tM+P32HftF4wFGNZcHDWKh6v8+Dx9kE+Wlh
	 qABun5nxOi42aBAt6nbn8xuS/WknQhCPiWmgdiL9mJfqGILrWahVQt1M1SdUrlYYBW
	 oYcJ9qB3XVRgBjaEKuDaOS4TiOoFSNp/ev8Z/E14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1263/1536] clk: qcom: ipq5018: add 24MHz rate for USB UTMI clock
Date: Sat,  7 Nov 2026 08:54:39 -0500
Message-ID: <20261107135033.244591028@linuxfoundation.org>
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

From: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>

[ Upstream commit 75e893169fc5c9ec28d5f9dffde40ce29b59a5de ]

The USB UTMI reference clock must operate at 24 MHz, as recommended
by the hardware team, for reliable USB operation.

Validation showed that USB 3.2 hub enumeration with USB 2.0 devices
fails when the UTMI reference clock is not configured to the required
24 MHz rate. Configuring the UTMI reference clock to 24 MHz to resolve
the enumeration failure and ensure successful device detection.

Cc: stable@vger.kernel.org
Fixes: e3fdbef1bab8 ("clk: qcom: Add Global Clock controller (GCC) driver for IPQ5018")
Signed-off-by: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260921-ipq_clk_changes-v1-1-d242e3d49648@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq5018.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/gcc-ipq5018.c b/drivers/clk/qcom/gcc-ipq5018.c
index 1a47e7e58ab85..9735cdf189085 100644
--- a/drivers/clk/qcom/gcc-ipq5018.c
+++ b/drivers/clk/qcom/gcc-ipq5018.c
@@ -1270,6 +1270,7 @@ static struct clk_rcg2 usb0_master_clk_src = {
 };
 
 static const struct freq_tbl ftbl_usb0_mock_utmi_clk_src[] = {
+	F(24000000, P_XO, 1, 0, 0),
 	F(60000000, P_GPLL4, 10, 1, 2),
 	{ }
 };
-- 
2.53.0



