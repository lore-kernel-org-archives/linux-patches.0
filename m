Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8BE1D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="thqbL7Tg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933AAC433C8;
	Wed,  4 Oct 2023 18:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443659;
	bh=sq+0UgHVg0s+Yru6lJ8YjQj4gTAJrxB5lYT7yw1StN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=thqbL7Tgzw5ZXzXtN5OlX8IYO2AkqzWem21+GaUEUNKwDlmBLYGRKkIv6+qO425MA
	 dzMFOHPogdGQ8DU15PKjiV7ZxQYwCWoSLdQavg8Sg/nGfQJsL9WzZ/mCSTGyznLz+w
	 iZA/EXWLf/CTlVu+WZknfQLrS0AIZpqfX4m3S/mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Tomer Maimon <tmaimon77@gmail.com>,
	Bruce Ashfield <bruce.ashfield@gmail.com>,
	Jon Mason <jon.mason@arm.com>,
	Jon Mason <jdmason@kudzu.us>,
	Ross Burton <ross@burtonini.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Mikko Rapeli <mikko.rapeli@linaro.org>
Subject: [PATCH 6.1 235/259] arm64: defconfig: remove CONFIG_COMMON_CLK_NPCM8XX=y
Date: Wed,  4 Oct 2023 19:56:48 +0200
Message-ID: <20231004175228.162526155@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikko Rapeli <mikko.rapeli@linaro.org>

commit 7d3e4e9d3bde9c8bd8914d47ddaa90e0d0ffbcab upstream.

There is no code for this config option and enabling it in defconfig
causes warnings from tools which are detecting unused and obsolete
kernel config flags since the flag will be completely missing from
effective build config after "make olddefconfig".

Fixes yocto kernel recipe build time warning:

WARNING: [kernel config]: This BSP contains fragments with warnings:
...
[INFO]: the following symbols were not found in the active
configuration:
     - CONFIG_COMMON_CLK_NPCM8XX

The flag was added with commit 45472f1e5348c7b755b4912f2f529ec81cea044b
v5.19-rc4-15-g45472f1e5348 so 6.1 and 6.4 stable kernel trees are
affected.

Fixes: 45472f1e5348c7b755b4912f2f529ec81cea044b ("arm64: defconfig: Add Nuvoton NPCM family support")
Cc: stable@kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Bjorn Andersson <quic_bjorande@quicinc.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: Neil Armstrong <neil.armstrong@linaro.org>
Cc: Tomer Maimon <tmaimon77@gmail.com>
Cc: Bruce Ashfield <bruce.ashfield@gmail.com>
Cc: Jon Mason <jon.mason@arm.com>
Cc: Jon Mason <jdmason@kudzu.us>
Cc: Ross Burton <ross@burtonini.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mikko Rapeli <mikko.rapeli@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/configs/defconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -1050,7 +1050,6 @@ CONFIG_COMMON_CLK_FSL_SAI=y
 CONFIG_COMMON_CLK_S2MPS11=y
 CONFIG_COMMON_CLK_PWM=y
 CONFIG_COMMON_CLK_VC5=y
-CONFIG_COMMON_CLK_NPCM8XX=y
 CONFIG_COMMON_CLK_BD718XX=m
 CONFIG_CLK_RASPBERRYPI=m
 CONFIG_CLK_IMX8MM=y


