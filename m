Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253272571C3;
	Mon, 24 Feb 2025 14:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408645; cv=none; b=QjL/cUC63us6pTPm3N9HkYNWaj27wXZpZEperYqIu1+K4iBLMjxKUciZZeq7AUqXYfAjUdQqHxaaigI0cbgiUB0pbLVFZa6Q9r3wLzO64SpMwI4qxEqZY2NHApKV8e1pbtd2VsMyHdoxsQvyhkgyrEciAgWPA+YCQoiLv3Jd+4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408645; c=relaxed/simple;
	bh=8s17+p+KNs6fKzfGyCCkE16//HSsfUu26MadFkSpEMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0C+vjzQPqekSA6O/gEsQUmY6O9Bw9gQyu11Lrw1bgyURW2OOx9yX+ouJeOZO3XQnX9NzoUtG4ZoVO8tmoTmN3U3yF3zOvgPK5Yw3m1KM+2JSRFArVHKCjo+mvp9njxgDAX4veMAenXyzOlDPkXidLF0vqucxE5fVlbW17L33no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FUKxzDTf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FUKxzDTf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 873EBC4CED6;
	Mon, 24 Feb 2025 14:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408645;
	bh=8s17+p+KNs6fKzfGyCCkE16//HSsfUu26MadFkSpEMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FUKxzDTfpaEse7Dfk/yMj1ttEE2uYyXGYEEK+JLGHNQGA67b/Z5+CNLWd2dFXCSUj
	 A3JrB0NXpvmuucA140pjnuSPwxLDwVktc4afy7dy5ieQDfAcKTLv3HzjsMksV785bG
	 YFVxUP3BxeymX1JaDzpwuRJMotAHY/xNvd8necU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 091/154] platform: cznic: CZNIC_PLATFORMS should depend on ARCH_MVEBU
Date: Mon, 24 Feb 2025 15:34:50 +0100
Message-ID: <20250224142610.634092563@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit dd0f05b98925111f4530d7dab774398cdb32e9e3 ]

CZ.NIC's Turris devices are based on Marvell EBU SoCs.  Hence add a
dependency on ARCH_MVEBU, to prevent asking the user about these drivers
when configuring a kernel that cannot run on an affected CZ.NIC Turris
system.

Fixes: 992f1a3d4e88498d ("platform: cznic: Add preliminary support for Turris Omnia MCU")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/cznic/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/cznic/Kconfig b/drivers/platform/cznic/Kconfig
index 49c383eb67854..13e37b49d9d01 100644
--- a/drivers/platform/cznic/Kconfig
+++ b/drivers/platform/cznic/Kconfig
@@ -6,6 +6,7 @@
 
 menuconfig CZNIC_PLATFORMS
 	bool "Platform support for CZ.NIC's Turris hardware"
+	depends on ARCH_MVEBU || COMPILE_TEST
 	help
 	  Say Y here to be able to choose driver support for CZ.NIC's Turris
 	  devices. This option alone does not add any kernel code.
-- 
2.39.5



