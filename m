Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717FB25A2A5;
	Mon,  9 Jun 2025 13:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749476765; cv=none; b=tiqQZyqGB+G1Whgd0Ula5P4Opcfh/QxODpr2hJrlOLtutEIhkVB24tqQvRZGNpmQsoMzHQsDhHetuwrXR2RIjb3KE9Ra0ReTgjKgoqo84R1rYDDWMjKn6DRK2JSWIc9MCT67G8NvGREOsAO7rP5QiOuN5cUSWbPJZ5mZjRE6k2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749476765; c=relaxed/simple;
	bh=x8vKi9OeBHwvOMcm/cpO7Y6gu4WwmmCq7IwnS3GP0Mk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jUlwh3Zidh3TeLhcRbsAspWVJtFxxVINJPsZMlxqSFUL1Q21KAIfpE4EduqbfC9pfRqYmoP4XlZpHjLCOmgFcTab9+uxB1OtsAUwR2wTDXr7Pl+W9Hrg2khUg1SvN5ADjFwxjwSdvH4aYUKReg1yGMaRZce8znGc3ce5aewBfac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e3ITZSjU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e3ITZSjU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4847DC4CEEB;
	Mon,  9 Jun 2025 13:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749476765;
	bh=x8vKi9OeBHwvOMcm/cpO7Y6gu4WwmmCq7IwnS3GP0Mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e3ITZSjUSQGaIGK3YYJEf8GZ4XW4S7RY6L8D+UIhcgJfwpWyPguEZ9SGbUeiwlMwR
	 A+7Nocqq4PGTKppllWwLvy4r7uSamyqgMOGqgFkoGasFnn+LpOrAyR2lgYmEmP/XR7
	 KY6i5H6DV3zESdD+l45/ZSGVCK1IqsjXsuyTWKWr0Uwb3NyAy32ksBN2G62sR6WAJl
	 5HVQ3disCZ5m7i9c1sstoOigfhzqOJoahppWljImQ9I0ej9LgOO8yY5oFRpSX9MU1X
	 FZsTrWX/wAy6G1dAkILZmhnWmPaka43j1XeABF+EqHT9tN+YQZtdGVp0SAZNGFwCl3
	 BXemq3Hd1YGmQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	andre.draszik@linaro.org,
	amitsd@google.com,
	u.kleine-koenig@baylibre.com
Subject: [PATCH AUTOSEL 6.14 27/29] usb: typec: tcpci: Fix wakeup source leaks on device unbind
Date: Mon,  9 Jun 2025 09:45:08 -0400
Message-Id: <20250609134511.1342999-27-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250609134511.1342999-1-sashal@kernel.org>
References: <20250609134511.1342999-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.10
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 9fc5986fbcd7e1e63afb04be94cd4e8a536a4b04 ]

Device can be unbound, so driver must also release memory for the wakeup
source.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250406204051.63446-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Excellent! Now I have a complete understanding of the issue. Based on my
analysis of the commit and the code:

**YES**

This commit should be backported to stable kernel trees.

## Analysis:

### **Code Change Analysis:**
The commit changes the `max_tcpci_probe()` function in
`drivers/usb/typec/tcpm/tcpci_maxim_core.c:539` from:
```c
device_init_wakeup(chip->dev, true);
```
to:
```c
ret = devm_device_init_wakeup(chip->dev);
if (ret)
    return dev_err_probe(chip->dev, ret, "Failed to init wakeup\n");
```

### **Resource Leak Issue:**
1. **Memory Allocation:** When `device_init_wakeup(dev, true)` is
   called, it internally calls `device_wakeup_enable()` which creates
   and registers a `wakeup_source` object via
   `wakeup_source_register()`. This allocates memory for the wakeup
   source structure and adds it to the global wakeup sources list.

2. **Missing Cleanup:** The original code has no cleanup mechanism. When
   the device is unbound (driver removal), the wakeup source remains
   allocated and registered, causing a memory leak.

3. **Fix:** `devm_device_init_wakeup()` uses the device resource
   management system. It calls `devm_add_action_or_reset(dev,
   device_disable_wakeup, dev)`, which ensures that
   `device_disable_wakeup()` (which calls `device_init_wakeup(dev,
   false)`) is automatically called when the device is removed, properly
   cleaning up the wakeup source.

### **Backport Suitability:**
This commit fits all the criteria for stable backporting:

1. **✅ Important Bug Fix:** Fixes a memory leak that affects users over
   time
2. **✅ Small and Contained:** Only 4 lines changed, very focused fix
3. **✅ No Side Effects:** Uses standard kernel resource management
   patterns
4. **✅ No Architectural Changes:** Just switches to managed resource API
5. **✅ Critical Subsystem:** USB Type-C is widely used and important
6. **✅ Minimal Risk:** `devm_device_init_wakeup()` is a well-established
   API
7. **✅ Follows Stable Rules:** Classic resource leak fix with minimal
   regression risk

### **Historical Precedent:**
This fix is identical in nature to Similar Commit #1 (gpio: mpc8xxx)
which was marked as "Backport Status: YES" and even has the same `Cc:
stable@vger.kernel.org` tag in its commit message. Both commits fix the
exact same type of wakeup source leak using the identical solution.

The commit addresses a real resource management issue that would
accumulate over time in systems where Type-C devices are frequently
bound/unbound, and the fix is both safe and standard.

 drivers/usb/typec/tcpm/tcpci_maxim_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/tcpm/tcpci_maxim_core.c b/drivers/usb/typec/tcpm/tcpci_maxim_core.c
index fd1b805933676..29a4aa89d1a14 100644
--- a/drivers/usb/typec/tcpm/tcpci_maxim_core.c
+++ b/drivers/usb/typec/tcpm/tcpci_maxim_core.c
@@ -536,7 +536,10 @@ static int max_tcpci_probe(struct i2c_client *client)
 		return dev_err_probe(&client->dev, ret,
 				     "IRQ initialization failed\n");
 
-	device_init_wakeup(chip->dev, true);
+	ret = devm_device_init_wakeup(chip->dev);
+	if (ret)
+		return dev_err_probe(chip->dev, ret, "Failed to init wakeup\n");
+
 	return 0;
 }
 
-- 
2.39.5

