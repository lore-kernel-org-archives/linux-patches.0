Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD3B2C08A2;
	Tue, 15 Jul 2025 22:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752620173; cv=none; b=bvFu9YRLIx0IAy/nvPnosavZcR+BrZKYpjC4SQtMaO89ym9UDdCU48bvv7nR+hrjhhRpsNWdultZu9/ZbVXn9RIgsx1VVunAmvgUs1ocE5lrFR9jaO3yrEe0kGjSi5A2W1L5ARZbkUFBJzTsBfo+4PDlQzT5/iUZeZbrTRK/4Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752620173; c=relaxed/simple;
	bh=5RyARkgf5SswMnaypfJWEGPx2OdRLTjBe9Y66ciJDKM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=YyVHco+aBG7d5hBZz/qComyUjNNIdCPQRPUsFKCWMi+Zhvg+HRx9cVRrRxeW8imFjfi4quMheDbW/AHsKgvEE5wJZQyfDggFt41PANPo88QqzmlAIHUNGoMDHsjQ7VUa67iYOo+zAqydwZjhjfv6xAShc8Wy61ZwIDblWmUWh5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HvL3ooAh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HvL3ooAh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 924C7C4CEE3;
	Tue, 15 Jul 2025 22:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752620173;
	bh=5RyARkgf5SswMnaypfJWEGPx2OdRLTjBe9Y66ciJDKM=;
	h=From:Date:Subject:To:Cc:From;
	b=HvL3ooAhAI7Ck8IC1tnJuXl9/v9R0vEEWBBKlTjw7Dmdurri+UdTRJ8M2LJCN/oGR
	 q8YIgqLhrT6taIHfMYy5H+aB7lOgP8Pk8k3eSrBi47jCc109LhxXUOlZRnMg29/JrD
	 Qb7ggiKK+vBDT7QDiGPwV686myWRhiLJGWnDLpuLQMdgVOfZnFom2iPkFOlJHpu1ZL
	 5JPEeDc+gU7kUoEloi6T/WmXwmYyeHETOluykIfeE65eCGC2yeJEZgnf1VaP/0j6lP
	 q/u176TotsAO+yx/LQw1d6Z5oCAbkL3JxPa8h7fpdrOnKpFF1azCk3RIXK121R3f9D
	 0IwTvis+cuJOA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 15 Jul 2025 15:56:05 -0700
Subject: [PATCH] memstick: core: Zero initialize id_reg in
 h_memstick_read_dev_id()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250715-memstick-fix-uninit-const-pointer-v1-1-f6753829c27a@kernel.org>
X-B4-Tracking: v=1; b=H4sIAITcdmgC/x2NwQrCMBAFf6Xs2YWktir+ivSgyUYf0k3JRhFK/
 73B48Aws5JJgRhdu5WKfGHI2sAfOgqvuz6FERtT7/rRnf3Is8xWEd6c8OOPQlE5ZLXKS4ZWKSz
 xlPzx8kiDi9Q6S5Hm/h+3adt2u2wy/nMAAAA=
X-Change-ID: 20250715-memstick-fix-uninit-const-pointer-ed6f138bf40d
To: Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>, 
 Ulf Hansson <ulf.hansson@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-mmc@vger.kernel.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, stable@vger.kernel.org, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2095; i=nathan@kernel.org;
 h=from:subject:message-id; bh=5RyARkgf5SswMnaypfJWEGPx2OdRLTjBe9Y66ciJDKM=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBlld7pfcXVfsUp2Kji0pLdpkkfnX7bDTSl1J5pidsas/
 8k0n+1iRykLgxgXg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZjIyY2MDB9PyH4L55/ie+Ph
 WYlFnDu3XvSXMeuM9U2/l7HMbPnyLZqMDD1cp1qqGzQ/Pf40feoOwbcm0l0Pjcp4Hr8waeA8VZ0
 fwQUA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

A new warning in clang [1] points out that id_reg is uninitialized then
passed to memstick_init_req() as a const pointer:

  drivers/memstick/core/memstick.c:330:59: error: variable 'id_reg' is uninitialized when passed as a const pointer argument here [-Werror,-Wuninitialized-const-pointer]
    330 |                 memstick_init_req(&card->current_mrq, MS_TPC_READ_REG, &id_reg,
        |                                                                         ^~~~~~

Commit de182cc8e882 ("drivers/memstick/core/memstick.c: avoid -Wnonnull
warning") intentionally passed this variable uninitialized to avoid an
-Wnonnull warning from a NULL value that was previously there because
id_reg is never read from the call to memstick_init_req() in
h_memstick_read_dev_id(). Just zero initialize id_reg to avoid the
warning, which is likely happening in the majority of builds using
modern compilers that support '-ftrivial-auto-var-init=zero'.

Cc: stable@vger.kernel.org
Fixes: de182cc8e882 ("drivers/memstick/core/memstick.c: avoid -Wnonnull warning")
Link: https://github.com/llvm/llvm-project/commit/00dacf8c22f065cb52efb14cd091d441f19b319e [1]
Closes: https://github.com/ClangBuiltLinux/linux/issues/2105
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/memstick/core/memstick.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
index 043b9ec756ff..7f3f47db4c98 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -324,7 +324,7 @@ EXPORT_SYMBOL(memstick_init_req);
 static int h_memstick_read_dev_id(struct memstick_dev *card,
 				  struct memstick_request **mrq)
 {
-	struct ms_id_register id_reg;
+	struct ms_id_register id_reg = {};
 
 	if (!(*mrq)) {
 		memstick_init_req(&card->current_mrq, MS_TPC_READ_REG, &id_reg,

---
base-commit: ff09b71bf9daeca4f21d6e5e449641c9fad75b53
change-id: 20250715-memstick-fix-uninit-const-pointer-ed6f138bf40d

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>

