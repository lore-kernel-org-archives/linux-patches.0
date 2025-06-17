Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D97E285063;
	Tue, 17 Jun 2025 16:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178795; cv=none; b=QBGDuMEFwS/J8kSrCT957Iq5Pc396iVZ17qSaEyNy8hwB2UeBW7bIrwkMqBU1go1gEogyukSPp1S4wrhaD3WL8wAC8ty5HHYRNLjL/IHCOTYPygQXgxdW1kM55/MooebmGHZr2kTyJ3v+BhTvjZh73MXMyE5XLo6lydVnw6d0yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178795; c=relaxed/simple;
	bh=EGx1Kz7PetJVhNNdX1b7R+ZRFQqYuD8fJQX9xlAjg2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZwAXBC/5EI+LIMNDvpdHPGYhXD1UGcokwG0/HvKY/S8JFe03Em5xwmizdiGq9AVW6RxTC5LN0RY7B2svAtJ/btUk3XxEwMhl8mzm/jYqeDUQYX3Aq+MP3l2ynqQ6vPmiSz99fxKseYEilcGSsMzJcPXVLBPOOkm5g7wdgj792D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qYXMCXD9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qYXMCXD9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1240C4CEE3;
	Tue, 17 Jun 2025 16:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178795;
	bh=EGx1Kz7PetJVhNNdX1b7R+ZRFQqYuD8fJQX9xlAjg2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qYXMCXD9kiK/kFqy8R78dxJ0tnF1F/BiWOVY9fb71OQqUoE+Oyh3c1XQzjOiR5duh
	 p2jAHRHMxLSBm0HcuJD9Ua0XEHhCIw2UFipm5gIFw5fqmpWp3VSlLT51TulOWKEmNT
	 t40XHUC3BLeVt3qvN6l4UFVSRB0oL/7aa1zD31fA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 557/780] drm/xe: Add missing documentation of rpa_freq
Date: Tue, 17 Jun 2025 17:24:25 +0200
Message-ID: <20250617152514.181798732@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Vivi <rodrigo.vivi@intel.com>

[ Upstream commit 40493d97b329f8185c0f04dc0ef2b9ffc58e7f3b ]

While at it, already adjust the rpe_freq frequency, to highlight
that both are calculated by PCODE at runtime.

Fixes: c6aac2fa77a3 ("drm/xe: Introduce the RPa information")
Cc: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Reviewed-by: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Link: https://lore.kernel.org/r/20250521165146.39616-4-rodrigo.vivi@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 39578fa40420fb11dbe4f42225a347e945d8fd0e)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt_freq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_gt_freq.c b/drivers/gpu/drm/xe/xe_gt_freq.c
index 985efbc685286..552ac92496a40 100644
--- a/drivers/gpu/drm/xe/xe_gt_freq.c
+++ b/drivers/gpu/drm/xe/xe_gt_freq.c
@@ -36,7 +36,10 @@
  * - act_freq: The actual resolved frequency decided by PCODE.
  * - cur_freq: The current one requested by GuC PC to the PCODE.
  * - rpn_freq: The Render Performance (RP) N level, which is the minimal one.
+ * - rpa_freq: The Render Performance (RP) A level, which is the achiveable one.
+ *   Calculated by PCODE at runtime based on multiple running conditions
  * - rpe_freq: The Render Performance (RP) E level, which is the efficient one.
+ *   Calculated by PCODE at runtime based on multiple running conditions
  * - rp0_freq: The Render Performance (RP) 0 level, which is the maximum one.
  *
  * device/tile#/gt#/freq0/<item>_freq *read-write* files:
-- 
2.39.5



