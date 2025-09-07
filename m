Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8066C1A0BFD;
	Sun,  7 Sep 2025 20:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277169; cv=none; b=d2G5xQnW6hsw7p/UkF2vxlFKSAKCMGp4YZ+AC2YdRQoxNOtoho0KXQksIoeLL5+vFrBDsirIhzxThtQzil0ZHt1Kckm1N2wte+QlgDd6AmYZTsJK74Rzfzw8RsxVL4N1fGUcsVHmTNj1sNu57e9J/ScUUSHDy6XC3xbW+utzPv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277169; c=relaxed/simple;
	bh=wgg1lqswwymiS9Tbs3uq5AG2pQuESldabiRJkiD3Q1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQYukGHwB9fH5OssjiaM1CnBXBCLXqIShWVlFRgr4aI4RjVJ/8w/qpH+rX6sazJN+TfcI5EQgQKJagHf7+knJD4bszz0A1dOdpGlbqhiDDKJDRckTAJnO4Lw2Wae7Br3Gh7N2nGC+d/Zjl+MUgexBwo342wSfA1jh0X0yPsdvqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nHNO5+O+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nHNO5+O+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F298BC4CEF0;
	Sun,  7 Sep 2025 20:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277169;
	bh=wgg1lqswwymiS9Tbs3uq5AG2pQuESldabiRJkiD3Q1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nHNO5+O+IfC+wdCIKdU7jbUmEcP/5eH7iRGgelqrHLwgckhhLhguTklx+p75nTwsv
	 JUnsbFLLgmtZ9obrLUqUWjrv1j2UrGrPLWcOoOAY5w2ZzWTu49/FnMTmQeEpwN/5BL
	 SUGjfxpuDeQIrdo+ltux/tA2towzs3yogoDp/klI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 107/175] soc: qcom: mdt_loader: Deal with zero e_shentsize
Date: Sun,  7 Sep 2025 21:58:22 +0200
Message-ID: <20250907195617.384626091@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>

commit 25daf9af0ac1bf12490b723b5efaf8dcc85980bc upstream.

Firmware that doesn't provide section headers leave both e_shentsize and
e_shnum 0, which obvious isn't compatible with the newly introduced
stricter checks.

Make the section-related checks conditional on either of these values
being non-zero.

Fixes: 9f9967fed9d0 ("soc: qcom: mdt_loader: Ensure we don't read past the ELF header")
Reported-by: Val Packett <val@packett.cool>
Closes: https://lore.kernel.org/all/ece307c3-7d65-440f-babd-88cf9705b908@packett.cool/
Reported-by: Neil Armstrong <neil.armstrong@linaro.org>
Closes: https://lore.kernel.org/all/aec9cd03-6fc2-4dc8-b937-8b7cf7bf4128@linaro.org/
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Fixes: 9f35ab0e53cc ("soc: qcom: mdt_loader: Fix error return values in mdt_header_valid()")
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-QRD
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250730-mdt-loader-shentsize-zero-v1-1-04f43186229c@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/mdt_loader.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/soc/qcom/mdt_loader.c
+++ b/drivers/soc/qcom/mdt_loader.c
@@ -39,12 +39,14 @@ static bool mdt_header_valid(const struc
 	if (phend > fw->size)
 		return false;
 
-	if (ehdr->e_shentsize != sizeof(struct elf32_shdr))
-		return false;
+	if (ehdr->e_shentsize || ehdr->e_shnum) {
+		if (ehdr->e_shentsize != sizeof(struct elf32_shdr))
+			return false;
 
-	shend = size_add(size_mul(sizeof(struct elf32_shdr), ehdr->e_shnum), ehdr->e_shoff);
-	if (shend > fw->size)
-		return false;
+		shend = size_add(size_mul(sizeof(struct elf32_shdr), ehdr->e_shnum), ehdr->e_shoff);
+		if (shend > fw->size)
+			return false;
+	}
 
 	return true;
 }


