Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0D6396573;
	Tue, 16 Dec 2025 12:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888322; cv=none; b=mJC+ArFrOc8O5Aaz44DRZKvOrEa7rFbkeqOiUC57mpW63WFphknZc0m+pcyKWrz2ivcEQ3Lz7TOCENKQsc7tHeN1sgWd21XUZwzq09GrEl2x2Pv8noAFQcLMpx82sFQUkwL68DKiGUw/kLe9fiio3tGevnWNWNox6++gwKwbMU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888322; c=relaxed/simple;
	bh=qiFabA/5MrvwfUOTBw0XKa8tYvMRtD0oX0mN3EcrV8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S1FN3r5QQtMC/pxi/9n4h2WfFANPTeJ8BjoJUmBEDwkHsIptyoiKdXdQu/0VgCDlNnpReClAeqpwl1y3hmtStyWYiMm3ttmOpF1qPTgdFVm4dG5aUW+lNvGR9r4uJW1zeSMxLKL2KJ1Jtt8mcumzf6/kmSWKZWj6CM+u9rLPdDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DX6dSIZH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DX6dSIZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D03C4CEF1;
	Tue, 16 Dec 2025 12:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888322;
	bh=qiFabA/5MrvwfUOTBw0XKa8tYvMRtD0oX0mN3EcrV8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DX6dSIZHI9oftLvnGzo/Z7a/Pb8sTcSNwC7KzhMw7gNQJoBURcLE0aFXQYtPVByPa
	 a49+cUJqWAOk71XFGpssuL14qHwlH4LJYGQoAL4IuvtQv0hNT0Uvtjc8kdMilt5E3D
	 pDHxqvf0vOZWxiCnI4Crr/xtC514dU/+OcYeyrik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 500/614] clk: keystone: fix compile testing
Date: Tue, 16 Dec 2025 12:14:27 +0100
Message-ID: <20251216111419.485470440@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit b276445e98fe28609688fb85b89a81b803910e63 ]

Some keystone clock drivers can be selected when COMPILE_TEST is
enabled but since commit b745c0794e2f ("clk: keystone: Add sci-clk
driver support") they are never actually built.

Enable compile testing by allowing the build system to process the
keystone drivers.

Fixes: b745c0794e2f ("clk: keystone: Add sci-clk driver support")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index b74a1767ca278..61ec08404442b 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -125,8 +125,7 @@ obj-$(CONFIG_ARCH_HISI)			+= hisilicon/
 obj-y					+= imgtec/
 obj-y					+= imx/
 obj-y					+= ingenic/
-obj-$(CONFIG_ARCH_K3)			+= keystone/
-obj-$(CONFIG_ARCH_KEYSTONE)		+= keystone/
+obj-y					+= keystone/
 obj-y					+= mediatek/
 obj-$(CONFIG_ARCH_MESON)		+= meson/
 obj-y					+= microchip/
-- 
2.51.0



