Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0909D302CB8;
	Sat, 25 Oct 2025 16:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409481; cv=none; b=LFuEEyLXfJsCdF9/SOWyVI0U7g0U0RU6ZR4gO+rT13+iF1Gail3hi/2iU8fRO16Ips74FByA4scs+SzyctC1qPK+hZS+Fm+MHPNCt15v2j10RNk9KeqsfISkovQAzn2QTeFTOALImdhA1+plhcaeX5mkdnxdrBPaqyiiw4j+wf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409481; c=relaxed/simple;
	bh=zZGa73oBDKVxP7AkmSQQThA4hlrdHelS5o8V02ZUs+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aOGBHIkvqgspNSk+13vc8+GoEOD6mjy/bvkSGNI1ycDekoFw0xudRL1X3BNUTaWQUaj21OxM3Es7I8QMuziJm0WwcCqhV0K4B33No2aTFjDo2n7TwEew3tB8Eoom6lp8ObHcVYLjc2YTUVzOCwVfXSK92butn75iDIOtk0mXl/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MIDP+U4v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MIDP+U4v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A7EC4CEFB;
	Sat, 25 Oct 2025 16:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409480;
	bh=zZGa73oBDKVxP7AkmSQQThA4hlrdHelS5o8V02ZUs+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MIDP+U4vtF8+JLA5aqSSZIvBYZQnfSEMFcVJt2yIj5cGy/RBgYP4r/IAd8YYW3Fav
	 q+YP9fqUzW3ZsyJEJ86mo//GNHGvqj/pL1764bFt3tyHrqyoIYUfXygklwEwYCzE2v
	 Rc89Dqhj0qzbV9edAqUMr/wiUUoo0C4leiya0qQpnu462YDr5/RKBC47eJeZkwFc7k
	 1cXNFJ7yx4CGkXNX4oSSM3Pjrf6raxmHioRuUn6opv7ulP1TXdg2sEHPP7dfnMwjId
	 Omhkk6fUNp7k6B4ZxEczKQyRAD0TsRDGnmHeo8Emz3LYpeINEXZwUXx71uFT1uKiL+
	 VHtAjrlfmaMFQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xiang Liu <xiang.liu@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	tao.zhou1@amd.com,
	ganglxie@amd.com,
	lijo.lazar@amd.com,
	candice.li@amd.com,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17] drm/amdgpu: Notify pmfw bad page threshold exceeded
Date: Sat, 25 Oct 2025 11:59:33 -0400
Message-ID: <20251025160905.3857885-342-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiang Liu <xiang.liu@amd.com>

[ Upstream commit c8d6e90abe50377110f92702fbebc6efdd22391d ]

Notify pmfw when bad page threshold is exceeded, no matter the module
parameter 'bad_page_threshold' is set or not.

Signed-off-by: Xiang Liu <xiang.liu@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

**Rationale**
- What changed
  - The call to notify the PMFW/SMU about an RMA reason
    (`amdgpu_dpm_send_rma_reason(adev)`) is moved outside the inner
    check that previously only executed for user-defined thresholds. Now
    it runs whenever the bad-page threshold is exceeded (and the feature
    isn’t disabled), regardless of whether the module parameter is left
    at default (-1) or formula-based (-2).
  - Reference: `drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c:772`
    (inner check for user-defined thresholds),
    `drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c:783` (unconditional
    PMFW notify within the threshold-exceeded block).

- Why it matters (bug fix, not a feature)
  - With the default (-1) or formula-based (-2) settings of
    `bad_page_threshold`, the driver already computes a threshold and
    warns when it’s exceeded, but previously did not always notify PMFW.
    This commit ensures PMFW is notified whenever the bad-page count
    crosses the computed threshold, aligning behavior across
    configurations and avoiding missed PMFW-side actions/telemetry.
  - Threshold semantics are documented and unchanged: -1 (default), 0
    (disable), -2 (formula), N>0 (user-defined). Reference:
    `drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c:979` (module param
    description), `drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c:980`
    (parameter definition); threshold computation paths:
    `drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:3283`,
    `drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:3289`,
    `drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:3292`.

- Scope and containment
  - The change is confined to a single function in AMDGPU RAS EEPROM
    handling and only adjusts when a single notification is sent. No
    architectural changes, no interface changes.

- Safety and regression risk
  - The PMFW notification path is robust: `amdgpu_dpm_send_rma_reason`
    guards for unsupported SW SMU and returns `-EOPNOTSUPP`; the caller
    ignores such failures by design (see comment just above the call).
    References: `drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c:782`
    (comment “ignore the -ENOTSUPP”),
    `drivers/gpu/drm/amd/pm/amdgpu_dpm.c:760` (unsupported check),
    `drivers/gpu/drm/amd/pm/amdgpu_dpm.c:763` (mutex),
    `drivers/gpu/drm/amd/pm/amdgpu_dpm.c:764` (SMU call),
    `drivers/gpu/drm/amd/pm/amdgpu_dpm.c:767` (return).
  - The driver continues to mark RMA in the EEPROM header (`ras->is_rma
    = true` and `header = RAS_TABLE_HDR_BAD`) only for user-defined
    thresholds, unchanged. Reference:
    `drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c:772` to
    `drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c:780`.
  - The feature remains disabled when `bad_page_threshold == 0`; the
    outer guard still requires `amdgpu_bad_page_threshold != 0`.
    Reference: `drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c:763`.

- User impact
  - Fixes a real behavioral gap: in common default/auto modes, PMFW was
    not being notified of threshold exceed events. This can affect
    reliability handling/telemetry on systems that rely on PMFW
    awareness. The fix is minimal, localized, and low risk.

Given the small, targeted nature of the fix, its correctness, and low
regression risk, this is a good candidate for stable backport.

 drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
index 9bda9ad13f882..88ded6296be34 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
@@ -774,9 +774,10 @@ amdgpu_ras_eeprom_update_header(struct amdgpu_ras_eeprom_control *control)
 				control->tbl_rai.health_percent = 0;
 			}
 			ras->is_rma = true;
-			/* ignore the -ENOTSUPP return value */
-			amdgpu_dpm_send_rma_reason(adev);
 		}
+
+		/* ignore the -ENOTSUPP return value */
+		amdgpu_dpm_send_rma_reason(adev);
 	}
 
 	if (control->tbl_hdr.version >= RAS_TABLE_VER_V2_1)
-- 
2.51.0

