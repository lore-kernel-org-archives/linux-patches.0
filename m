Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217378;
	b=kVqxgrrFVS1nW74xFFN8svYogBg/OBQcADpaTB8yw86gB26i+lmVDz0lng+S/97glW4N
	 FVXeycMYv9wA7vkOPya9AdGDd4/3moSF2pAmQW9JrdFJZtU2U55kSLTcgwHmyr12AQV3M
	 dMR/r3rnbLh6KV3ed+Ze2tTeQ+WNNVGaFMSzWnRP1BIi+0b2DV25PjiqvNTEG/H+eWlH+
	 Ymr+osEXNdyLf2/XIHz23+ZTaXlveXHv6y7B0rV+Qj2W4g4y7Cijmfg0cthC9Wyd2QqzE
	 TTPZYuN1yZPrixxk/Bd35BR/QHlMMbJEJ3fMDVnchGyM1RLpLWoZZFpS6B9mo4s2VPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217378;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=McYULF9N9GdCOqVmh7xu4t20d31j2qgu6YChLY8XJ6k=;
	b=NpYIVfFrZyBG9YQAzqY2X2HTbPj99+T8AYGLrEZ2YA8be7yFhajyNc1DPXJpJ8FbT6a6
	 foVvvHMpBOCRfCDsv3bj023bG4yoiACnOT0hYyIzVuze6h6VtABLJYTwoY4hAzpQDlfkB
	 /CLutcwjqJsz4j59wtsKrcUq7L0BanCsz5yk329oRwfn9s93uhZbqxWjBbjSX2yxBbE/P
	 iaM2f5ZTN3x194OlgaYDtIJjvXJqSsooCraEgG+hufwGKnY4OpEIFCm40rPHO2hFZym7/
	 VwvpKhKhhJJLDYb7xGxJLA2E2as7m0Qkzyfan2SoumkfX6dSc3NLQLm2yoqyUDxOijg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z4YSF5cQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2D1606A31C;
	Wed, 28 Oct 2026 19:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z4YSF5cQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3908E1F01828;
	Wed, 28 Oct 2026 19:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217377;
	bh=McYULF9N9GdCOqVmh7xu4t20d31j2qgu6YChLY8XJ6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z4YSF5cQTFyQygOPZSyD+116H+nika7R5SVLWDZ2ooiMHfpxBy81q1eYiO1Xf7nxH
	 T1jPG0c8PbafHKP/3p5+9gTa1a0/CN7F+2mgs3mi8Er2u+kvSJV6p0Lpa0p9B06BbH
	 NSedzpcTGaJ6cULBZJ0xaIR6743ew9iUXiMkDH3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1839/1887] firmware: arm_scmi: Unregister device notifier before IDR teardown
Date: Wed, 28 Oct 2026 18:05:35 +0100
Message-ID: <20261028170541.297596327@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit 66a0bbf30cc14140fe13f63cd594a7c1ee352b75 ]

The requested-devices notifier looks up protocol fwnodes from the
active_protocols IDR. During remove, unregister the notifier before
releasing and destroying active_protocols so no notifier callback can race
with the IDR teardown.

Keep the bus notifier registered until after the protocol state is torn
down, matching the existing remove ordering for SCMI bus users.

Fixes: 53b8c25df708 ("firmware: arm_scmi: Add common notifier helpers")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20260714-scmi_core_fixes-v6-2-3afe499d46e3@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index f0a9a1bfdf958..57c608ebb0bbe 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -2462,6 +2462,9 @@ static int scmi_remove(struct platform_device *pdev)
 	list_del(&info->node);
 	mutex_unlock(&scmi_list_mutex);
 
+	blocking_notifier_chain_unregister(&scmi_requested_devices_nh,
+					   &info->dev_req_nb);
+
 	scmi_notification_exit(&info->handle);
 
 	mutex_lock(&info->protocols_mtx);
@@ -2472,8 +2475,6 @@ static int scmi_remove(struct platform_device *pdev)
 		of_node_put(child);
 	idr_destroy(&info->active_protocols);
 
-	blocking_notifier_chain_unregister(&scmi_requested_devices_nh,
-					   &info->dev_req_nb);
 	bus_unregister_notifier(&scmi_bus_type, &info->bus_nb);
 
 	/* Safe to free channels since no more users */
-- 
2.53.0



