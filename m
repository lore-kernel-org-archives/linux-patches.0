Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30ED3019CB;
	Mon,  9 Feb 2026 12:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770640059; cv=none; b=edswYl7B3IBjpEDzLclzIbeChmmZvBBrqyTWzf0OA2fAJOvunL5jljF+UGKWn0DZbbG1oA2bxDzxJHBf9LR4eA4lGi7Fariu4WHC4OM4xaH12v4IGNYfXlH8hHToBrUqq46ItPDO9aMPksMbuZxityGwTSfHJCu7gFpAhZibR4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770640059; c=relaxed/simple;
	bh=wMhQZqLjwM1T+1hINqzNCY03T81jmm8Tl1VlJSahJnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MB4Ba6G3npnoTstxxKpVOzT8eJOP8WP1ggDs+3J5Qz2fFRqCWPzjjOEbrLh8x1ucBVTzL4KiUyj53b3LsUaWnKnm88iUY64S1vabZcEa0SI6JLLeaGItArnjCRZd0fM9sSl7qifWX7IEvfxFsAaFy/J2byT/QCx4rcnTo0BZ8yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BPu+hEpd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BPu+hEpd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BBD2C19423;
	Mon,  9 Feb 2026 12:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770640059;
	bh=wMhQZqLjwM1T+1hINqzNCY03T81jmm8Tl1VlJSahJnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BPu+hEpdJT1jYFx6fUGxiEMlNSSZRKOolVXpHU+XIatXNUrZui8os6Gc+GGUZAAkz
	 u+fWjfH9+z2lfpUvyyxU6ERCwegbLaWZX7Eey/t/vuY3tlnTZCCk4deto5HM1mecyN
	 XjIMo3XxP1XqeZXbxJzPI7Og4vwNYJ6gLUJVEaCI2BPKdqmR0VesvnvhGfRuT4z4iv
	 CLk18jcj16ct/r8wAf1hfm9GdKYm33WOx6MJjTkfcuDaHXCuGHDTbZnaTl8Gn0hhvq
	 m6qEdJa32XUxa7ieXhH1b2OawV6DlXHW0alv2xGb5I2pZFkm0H5XEDQxkUD9W2UWNJ
	 hTOuhev5d0jkQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alban Bedel <alban.bedel@lht.dlh.de>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	westeri@kernel.org,
	andriy.shevchenko@linux.intel.com,
	linusw@kernel.org,
	brgl@kernel.org,
	linux-gpio@vger.kernel.org,
	linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] gpiolib: acpi: Fix gpio count with string references
Date: Mon,  9 Feb 2026 07:26:52 -0500
Message-ID: <20260209122714.1037915-13-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260209122714.1037915-1-sashal@kernel.org>
References: <20260209122714.1037915-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.9
Content-Transfer-Encoding: 8bit

From: Alban Bedel <alban.bedel@lht.dlh.de>

[ Upstream commit c62e0658d458d8f100445445c3ddb106f3824a45 ]

Since commit 9880702d123f2 ("ACPI: property: Support using strings in
reference properties") it is possible to use strings instead of local
references. This work fine with single GPIO but not with arrays as
acpi_gpio_package_count() didn't handle this case. Update it to handle
strings like local references to cover this case as well.

Signed-off-by: Alban Bedel <alban.bedel@lht.dlh.de>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://patch.msgid.link/20260129145944.3372777-1-alban.bedel@lht.dlh.de
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The prerequisite commit appeared in v6.10+. So the bug affects stable
trees from 6.10 onward (6.10.y, 6.11.y, 6.12.y, etc.).

### 7. CONCLUSION

This commit:
- **Fixes a real bug**: GPIO array counting fails when ACPI firmware
  uses string references
- **Is obviously correct**: Adding a switch case for strings to match
  the same handling as local references
- **Is minimal**: One line addition
- **Has zero risk**: Cannot affect existing code paths; only enables a
  new case in a switch statement
- **Has been reviewed** by the ACPI/GPIO maintainer (Mika Westerberg)
  and merged by the GPIO maintainer (Bartosz Golaszewski)
- **Has a clear dependency**: Only applies to trees with commit
  `9880702d123f2` (v6.10+)
- **Fixes real hardware support**: Users with firmware using string
  references for GPIO arrays would have broken device functionality

This is a textbook stable backport candidate: small, surgical, correct,
and fixes real user-impacting functionality.

**YES**

 drivers/gpio/gpiolib-acpi-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpiolib-acpi-core.c b/drivers/gpio/gpiolib-acpi-core.c
index e64e21fd6bbaa..8110690ea69d0 100644
--- a/drivers/gpio/gpiolib-acpi-core.c
+++ b/drivers/gpio/gpiolib-acpi-core.c
@@ -1359,6 +1359,7 @@ static int acpi_gpio_package_count(const union acpi_object *obj)
 	while (element < end) {
 		switch (element->type) {
 		case ACPI_TYPE_LOCAL_REFERENCE:
+		case ACPI_TYPE_STRING:
 			element += 3;
 			fallthrough;
 		case ACPI_TYPE_INTEGER:
-- 
2.51.0

