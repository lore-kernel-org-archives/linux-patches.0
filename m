Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064134;
	b=a0ihjP1IYVrUrS9R+K0MrK0XaBHmVnA9aShBY3D/rLJ4WXVD9KBPkOhob+fBLOdD5G4J
	 FDc7ngBYs436YhKbAizpM4dwgNemOXWradWGjjh1lBGAhkIqXq396eTr22bghyKgViMFR
	 xG8Ahu3NMEqngNa+wztEqCEfVGj89LYZ2N1/RhbdDeJLgBIRCz2aRzS8Q0oW8SgUno3uy
	 Z7erjWCrCC1/f33LQFxscgfkfBYwy9n1BGebTpjNUzNEXZo/LiD5H9GRW/rQXpRn50JpQ
	 2Q8eyHjdOsSo8XGUFabJecDeGfXXOR7Du4DMu94JHzW2ZhfO3JV7RdhHyLTGVZbFb3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064134;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mNp3esfsGyPi2Ao+g/DLroXg/7KobtNedejW6kUCB70=;
	b=E06kwY4FOSF9IM8liyJ7s8KeYenNMosWE2mYvBw9mEMmy5GCZXeUS8DJUhYk8FFC3k6M
	 T+hna0XbBQubZBqHe0vXm4hP0lgeMetYv8UMsciaeMzjxlCor3mGjX37JXjgb4FbbKi9C
	 KzJvhw8GNhrPg8Y6KWJ5vpgmPXQpKubtKnjvfLXEDkntDEt6cqWs5VvSTWsa4o97MT78E
	 YWHkqZ5CIZOEuY2sMXILpD9M8cFKAOEDMQnjWBGo2Hrk+8ITn4otC91cZJPn2JNwwNCM2
	 hWC3b897+vscvCQwLYcLIWgy/XJkLcKzha8pQIf4c0EC9WcOoZMk58GxqEIr2pCIM8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="V7p7dTb/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0D4606A33B;
	Sat,  7 Nov 2026 15:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V7p7dTb/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06951F0089F;
	Sat,  7 Nov 2026 15:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064134;
	bh=mNp3esfsGyPi2Ao+g/DLroXg/7KobtNedejW6kUCB70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V7p7dTb/hO2dgWFYf0SwZI1ZmG1mhH8MwroUmOqlq27zpK2bu/D08+k+J7IdLLi/e
	 oIl6LjaHzvC20knePtD0Lqkk4umHB2mSc0SVN+ELEbZJDV+LAyG81eRvarCI8sHhoh
	 jsKJeRWf+iZJUrhvtsk3Ckd9Wb7ckLCOHAx4961s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0285/1257] mfd: wcd934x: Fix NULL pointer dereference on IRQ probe deferral
Date: Sat,  7 Nov 2026 08:43:01 -0500
Message-ID: <20261107134947.345581790@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Heidelberg <david@ixit.cz>

[ Upstream commit dcf0e640b553d33512fbcaedb909c32ba9636a64 ]

ddata->dev is only assigned at the end of wcd934x_slim_probe(), but the
of_irq_get() error path has passed it to the error print since the
driver was added, while it is still NULL.

This used to be harmless with dev_err(), which copes with a NULL device
and was skipped on -EPROBE_DEFER. Since the switch to dev_err_probe(), a
deferred IRQ reaches device_set_deferred_probe_reason() ->
dev_driver_string(), which dereferences the NULL pointer and crashes
during probe. Use dev, which is already valid at this point.

Cc: stable@vger.kernel.org
Fixes: 0f1b1b899521 ("mfd: wcd934x: Simplify with dev_err_probe()")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/mfd/20260903145651.AC1311F00ACA@smtp.kernel.org/
Signed-off-by: David Heidelberg <david@ixit.cz>
Link: https://patch.msgid.link/20260903-wcd-dma-v3-1-d3920c6563c4@ixit.cz
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/wcd934x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/wcd934x.c b/drivers/mfd/wcd934x.c
index 7bea64fc09562..d57796933d873 100644
--- a/drivers/mfd/wcd934x.c
+++ b/drivers/mfd/wcd934x.c
@@ -229,7 +229,7 @@ static int wcd934x_slim_probe(struct slim_device *sdev)
 
 	ddata->irq = of_irq_get(np, 0);
 	if (ddata->irq < 0)
-		return dev_err_probe(ddata->dev, ddata->irq,
+		return dev_err_probe(dev, ddata->irq,
 				     "Failed to get IRQ\n");
 
 	ddata->extclk = devm_clk_get(dev, "extclk");
-- 
2.53.0



