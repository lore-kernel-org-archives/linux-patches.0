Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D71D25A35D;
	Mon,  9 Jun 2025 13:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749476706; cv=none; b=PsZUnkCMEABThdfUxysDCgqL5g0oCFXWL6LEqPjurHMCADkJjdIHgjNapJdEd8+E2waEZVPoj9l1r+PhrPF5FH9R3asTdtpwgCl9KIGMssE1e4Sp0W8iFjjye5aP66PdByWgZ1sX/OOUMg+tYA4t62NdixePxSe3SzN+CI3Tyn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749476706; c=relaxed/simple;
	bh=x8vKi9OeBHwvOMcm/cpO7Y6gu4WwmmCq7IwnS3GP0Mk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kh9qMfmhfif2X7endxbUSih0SaP/nqFGA3fZsa70zJ0QbPNJTaofskMZ1ypZWVzF8DY3EWI7k4v2JsthszKz01mWTQtHV9Z1OR3aYLe20X+FJxSLU35lJhAbeIU5eOzNu1VvwtYYUzuQxg7XDMELaer92FLHNYkK/ZfjJP9dztw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hAGNtPKH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hAGNtPKH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF85C4CEED;
	Mon,  9 Jun 2025 13:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749476705;
	bh=x8vKi9OeBHwvOMcm/cpO7Y6gu4WwmmCq7IwnS3GP0Mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hAGNtPKHirO9Gvz6vm29U5S8SRlr55X3DcFSfOXgk5uQOMtyAjXFjWobYsQOdxODe
	 /xAjfPvd9gRKcpE+RP8MRN5OmcMTS6iBkr5ESPzu0NSry6ilYSiR88iZTUwfCUnmVJ
	 4v4Zlb39hIYubjZVPJAWRjZijf6A0pKmx+qjnnpDYhhbQpHUkOfRRgUK8a1pmvq84l
	 UYDPkmhLM5+VavDQN9gheY/bZtEF82DGncbh0+atN1koVBMQqHhkZaNd3bsSPJncVl
	 C+xGAoORMfx0pGcnn3xZkYhLQib2tI4CO98Tk4keWVR9s0MJMThTer8qOuEHI7oErU
	 nx/R93D3uzoXA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	andre.draszik@linaro.org,
	kyletso@google.com,
	amitsd@google.com,
	u.kleine-koenig@baylibre.com
Subject: [PATCH AUTOSEL 6.15 33/35] usb: typec: tcpci: Fix wakeup source leaks on device unbind
Date: Mon,  9 Jun 2025 09:43:49 -0400
Message-Id: <20250609134355.1341953-33-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250609134355.1341953-1-sashal@kernel.org>
References: <20250609134355.1341953-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.1
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

