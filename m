Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDE33368B8;
	Tue, 21 Jul 2026 17:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655748; cv=none; b=Gs63kJkWGxKhH3HgqPe1Oqi+wp5+PqcOvrRHCzyeWK/DMG6mCxTjvQ7lfJDJXUlZMhHUIHNT04GkylZj7EPA8p4uD9AH9LkKsbIT1YjNK5wifnz2Z5y3CtORpGr8Xfcwa7Pbiz2S/bWs27e//Ol04B4wBuV16YxQK6MXBV3EPt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655748; c=relaxed/simple;
	bh=5lLxKAmgXZkyFdnenWKc6JCh5x4aqdRIWTJIMRXJZ7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1WzdpDQ3y9BbyM1b0/O1+lE5l9atBhlvdsZw5aRDDbPkqTQ1wESNzAymuuWpdiFHXw9CD076jFL7kI5KxvdW6cV9eSLRcXziqSh5qZBqaMmtwm9jza+wqFSw7Kd6ygNs7LT5v89i+D169o/VcR7epJS5g228F4STj5dyGmR2dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZtDisM0z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZtDisM0z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9334B1F000E9;
	Tue, 21 Jul 2026 17:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655747;
	bh=9Vru9VBeucdEv3Bwu19jG58Gpcu/SUzOodfqwLXaY/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZtDisM0zscMScRe/JPPDmPy88C2GfgxAxVdLj424HVeca3ChIupiRcUVuJwspJrAm
	 yqdEUw9DLBoyKK0D6oxWQ+2MqPHiz2vpvqsAoQ6vja9W4ZJc8QEXsY1/UwYJvsAv1J
	 wfOP9RGOWtvof6VEfYYXlVxITgux1QUxGZ56rn1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0125/1611] ARM: multi_v7_defconfig: Correct QCOM_RPMH and QCOM_RPMHPD
Date: Tue, 21 Jul 2026 17:04:01 +0200
Message-ID: <20260721152517.675403864@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit 02802b40c31d2f2cfc94716189cfaf610930c589 ]

QCOM_RPMH and QCOM_RPMHPD can be build only as modules when
QCOM_COMMAND_DB is module itself.

Fixes: 1c25ca9bb5c5 ("ARM: multi_v7_defconfig: enable more Qualcomm drivers")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/configs/multi_v7_defconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 12f706e2ded541..2707c4c5022642 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -1117,7 +1117,7 @@ CONFIG_QCOM_COMMAND_DB=m
 CONFIG_QCOM_GSBI=y
 CONFIG_QCOM_OCMEM=m
 CONFIG_QCOM_RMTFS_MEM=m
-CONFIG_QCOM_RPMH=y
+CONFIG_QCOM_RPMH=m
 CONFIG_QCOM_SMEM=y
 CONFIG_QCOM_SMD_RPM=y
 CONFIG_QCOM_SMP2P=y
@@ -1135,7 +1135,7 @@ CONFIG_KEYSTONE_NAVIGATOR_QMSS=y
 CONFIG_KEYSTONE_NAVIGATOR_DMA=y
 CONFIG_RASPBERRYPI_POWER=y
 CONFIG_QCOM_CPR=y
-CONFIG_QCOM_RPMHPD=y
+CONFIG_QCOM_RPMHPD=m
 CONFIG_QCOM_RPMPD=y
 CONFIG_ROCKCHIP_PM_DOMAINS=y
 CONFIG_TI_SCI_PM_DOMAINS=y
-- 
2.53.0



