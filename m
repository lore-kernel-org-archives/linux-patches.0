Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A381F4168;
	Sat, 14 Feb 2026 01:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031056; cv=none; b=iHyzMHT+DQqOclqOIAgXAtE2btg1DfChAGBt27xiE4voH837v7yy8Ztq0x+jigRMk3gp0/l5RtDBgDaj6oOfkUrvwF+8zCnS3ecRETsOFMkFEgxaHZu2f0yofqSJgkQ5CpQV75MueC3XvFTKBJ6wbRzIWt0jeRJ9Q5SMIDjLtTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031056; c=relaxed/simple;
	bh=75+k/chSxeLUbhgX1iGsAcKtfO12wDxe1HdLTw9qOus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pJ1kAsK0h+Eg1XjHNRmBqmfSIaj+ddvl+Gr++2LNtn8wXYPo8BDxmeZoFt37H49NIDIhImRQEv4/aDq/LA4eBuvnIHoFyQKuEV4aGAnUn5dHz/xyH6JBdfU/RHocYbz8E+wyawEmkKaTszjCCMsjAmUwj4bZvwtMfDW8cZGs5Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R0ytTrNc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R0ytTrNc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FAE4C19423;
	Sat, 14 Feb 2026 01:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031055;
	bh=75+k/chSxeLUbhgX1iGsAcKtfO12wDxe1HdLTw9qOus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R0ytTrNceniuwCh5v0oD7cdibj3NfiMD0b9QpaMhVBNSRHRMnNOxacJ0/rqQSFNu4
	 PKI6Cx7uWb2CEAVl9/VR3TsprJsIeuCV+OPNK5U7oOZGc9M0fQILTaeGI45NDbmjLf
	 KkUeTZNwgZUhFpHMcAYQ9rDYYB8pCXmF43A7MEwok211ncMCsuQ5E3NPvQlvNC1Kk9
	 +YNxZI9Nb4seVf0AU1frgfFm/a/MQ54TF46rK8mrFuqsH5w+V5wbTiWZDhL/dyHgcl
	 ZWa7fuvYNfOW4blJh5j66uHDnGhgf02HXuGsZXfeLEdhzR933C5FVDgtTN39iXtZhN
	 o1fSA0cPzgKwQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chen Ni <nichen@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	ckeepax@opensource.cirrus.com,
	neil.armstrong@linaro.org,
	kuninori.morimoto.gx@renesas.com,
	srinivas.kandagatla@oss.qualcomm.com,
	yelangyan@huaqin.corp-partner.google.com,
	tiwai@suse.de,
	krzk@kernel.org
Subject: [PATCH AUTOSEL 6.19-6.1] ASoC: codecs: max98390: Check return value of devm_gpiod_get_optional() in max98390_i2c_probe()
Date: Fri, 13 Feb 2026 19:58:41 -0500
Message-ID: <20260214010245.3671907-41-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit a1d14d8364eac2611fe1391c73ff0e5b26064f0e ]

The devm_gpiod_get_optional() function may return an error pointer
(ERR_PTR) in case of a genuine failure during GPIO acquisition,
not just NULL which indicates the legitimate absence of an optional
GPIO.

Add an IS_ERR() check after the function call to catch such errors and
propagate them to the probe function, ensuring the driver fails to load
safely rather than proceeding with an invalid pointer.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Link: https://patch.msgid.link/20260130091904.3426149-1-nichen@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of max98390 devm_gpiod_get_optional() Return Value Check

### 1. Commit Message Analysis

The commit message clearly describes adding a missing error check for
`devm_gpiod_get_optional()`. The function can return an `ERR_PTR` on
genuine failures (e.g., deferred probe `-EPROBE_DEFER`, or actual GPIO
acquisition errors), but the existing code only handled the `NULL` case
(no GPIO present). Without the check, an `ERR_PTR` value would be
treated as a valid GPIO pointer, leading to undefined behavior.

### 2. Code Change Analysis

The change is minimal — 3 lines added:

```c
if (IS_ERR(reset_gpio))
    return dev_err_probe(&i2c->dev, PTR_ERR(reset_gpio),
                         "Failed to get reset gpio\n");
```

This is inserted immediately after the `devm_gpiod_get_optional()` call
and before `reset_gpio` is used. The subsequent code does:
- `if (reset_gpio)` — this branch would be entered if `reset_gpio` is an
  `ERR_PTR` (since `ERR_PTR` values are non-NULL)
- `gpiod_set_value_cansleep(reset_gpio, 0)` — this would dereference an
  invalid pointer

Without the fix, if `devm_gpiod_get_optional()` returns an error (e.g.,
`-EPROBE_DEFER`), the code would pass the error pointer to
`gpiod_set_value_cansleep()`, which would dereference an invalid
pointer, likely causing a **kernel crash/oops**.

### 3. Bug Classification

This is a **missing error check that can lead to an invalid pointer
dereference**. The most common real-world trigger would be
`-EPROBE_DEFER`, which happens during boot when GPIO controllers haven't
been probed yet. This is very common on device-tree platforms (ARM,
ARM64) where probe ordering isn't deterministic.

### 4. Scope and Risk Assessment

- **Lines changed**: 3 lines added
- **Files changed**: 1 file (`sound/soc/codecs/max98390.c`)
- **Risk**: Extremely low — it adds a standard error check pattern used
  throughout the kernel
- **Could it break something?**: No — it only adds early return on
  error; the normal (non-error) path is completely unchanged

### 5. User Impact

- The max98390 is a Maxim speaker amplifier codec used in real products
  (Chromebooks, laptops)
- On platforms with deferred probing, the bug could cause a kernel crash
  during boot
- The `dev_err_probe()` function is the correct idiom — it silences
  `-EPROBE_DEFER` messages and logs actual errors

### 6. Stability Indicators

- Accepted by Mark Brown (ASoC subsystem maintainer)
- Uses standard kernel error handling patterns (`IS_ERR`,
  `dev_err_probe`)
- Pattern is identical to hundreds of similar fixes already in stable

### 7. Dependency Check

- No dependencies on other commits
- The `devm_gpiod_get_optional()` function and `dev_err_probe()` have
  existed in stable kernels for a long time
- The max98390 driver exists in stable trees (added in Linux 5.6)

### Conclusion

This is a textbook stable-worthy fix: small (3 lines), obviously
correct, fixes a real bug (invalid pointer dereference on GPIO
acquisition failure), uses standard kernel patterns, has zero risk of
regression, and affects a real hardware codec driver. The bug is most
likely to trigger via `-EPROBE_DEFER` on ARM/ARM64 platforms, which is a
very common scenario.

**YES**

 sound/soc/codecs/max98390.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/codecs/max98390.c b/sound/soc/codecs/max98390.c
index 3dd4dd94bc371..ff58805e97d17 100644
--- a/sound/soc/codecs/max98390.c
+++ b/sound/soc/codecs/max98390.c
@@ -1067,6 +1067,9 @@ static int max98390_i2c_probe(struct i2c_client *i2c)
 
 	reset_gpio = devm_gpiod_get_optional(&i2c->dev,
 					     "reset", GPIOD_OUT_HIGH);
+	if (IS_ERR(reset_gpio))
+		return dev_err_probe(&i2c->dev, PTR_ERR(reset_gpio),
+				     "Failed to get reset gpio\n");
 
 	/* Power on device */
 	if (reset_gpio) {
-- 
2.51.0

