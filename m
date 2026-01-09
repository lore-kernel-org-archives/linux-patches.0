Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4FC32BF21;
	Fri,  9 Jan 2026 11:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959890; cv=none; b=RApPLRAy8g1p8Xf+1FaTG3cpNs5T3AXnS9mjndVVj/8xO4YDB2/NI3stRx7iAQipXRmjgFgrD6VXPnUBknJooxB0mS2G/p2kgBUFmHWABQbjj1feO40GUyqHjH3CHm5OeHyyy5lB8/vD1VHF+MXpvu4rDfjwBR2fJ6tFKnOODPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959890; c=relaxed/simple;
	bh=hJWODLjBWhbI9Y/h1fv+mBicUEgLs8eJXMvhofU74lU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khzgnSW3CZSH7Lm23og8k/DypK+qh4GhTuwEWoiJkS9JS17Vr+fBO9hjqD4fKgS8fZSvNtpDG5zecxSGbL+E8B/tSCc9fRfDUTuuHammW87Koqr1WrCW1qNIDiRqj2/0u7MMOGjkbTnOGn9uxGpVaA1KAUKy4VlvXUYSZagn+1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LS2heaEp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LS2heaEp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2EEC4CEF1;
	Fri,  9 Jan 2026 11:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959890;
	bh=hJWODLjBWhbI9Y/h1fv+mBicUEgLs8eJXMvhofU74lU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LS2heaEpaaXORkrZdhpW8zOp2tmOpincoSI5f3LMC7pkhpYOhIdgfdqvRYdhy9II1
	 kEe0FimoLVR5eqbxebSR4WysMmiE00jHiIERlZuhLYIrcHani0FMx1o4qMItdclSuo
	 bhFcA9ZaML1+KAlFgkkbAE7Sbp5BEDh5kpY7PXZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 210/737] backlight: lp855x: Fix lp855x.h kernel-doc warnings
Date: Fri,  9 Jan 2026 12:35:49 +0100
Message-ID: <20260109112141.898461242@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 2d45db63260c6ae3cf007361e04a1c41bd265084 ]

Add a missing struct short description and a missing leading " *" to
lp855x.h to avoid kernel-doc warnings:

Warning: include/linux/platform_data/lp855x.h:126 missing initial short
 description on line:
 * struct lp855x_platform_data
Warning: include/linux/platform_data/lp855x.h:131 bad line:
   Only valid when mode is PWM_BASED.

Fixes: 7be865ab8634 ("backlight: new backlight driver for LP855x devices")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Daniel Thompson (RISCstar) <danielt@kernel.org>
Link: https://patch.msgid.link/20251111060916.1995920-1-rdunlap@infradead.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/platform_data/lp855x.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/platform_data/lp855x.h b/include/linux/platform_data/lp855x.h
index ab222dd05bbc2..3b4a891acefe9 100644
--- a/include/linux/platform_data/lp855x.h
+++ b/include/linux/platform_data/lp855x.h
@@ -124,12 +124,12 @@ struct lp855x_rom_data {
 };
 
 /**
- * struct lp855x_platform_data
+ * struct lp855x_platform_data - lp855 platform-specific data
  * @name : Backlight driver name. If it is not defined, default name is set.
  * @device_control : value of DEVICE CONTROL register
  * @initial_brightness : initial value of backlight brightness
  * @period_ns : platform specific pwm period value. unit is nano.
-		Only valid when mode is PWM_BASED.
+ *		Only valid when mode is PWM_BASED.
  * @size_program : total size of lp855x_rom_data
  * @rom_data : list of new eeprom/eprom registers
  */
-- 
2.51.0



