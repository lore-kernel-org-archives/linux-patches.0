Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620918;
	b=uvyVvXSt+jZLMDuIAeDicw+eM6LO7iLcabRaDs/LiHvEZXGuJYvmRMsrI+Md1NN30dDc
	 bTojcgDQFjzuOsPiEHIW/aD0oGNnua2LC4vjbVd771Wre8Q7gVwe96fuFaqdPM5vaog3P
	 OzRLxPwiDCqexeNJ6dJciiYOTWjUhsoZEm3PAu87RUdHpI2eNd6eWKQ31Q+IfTnS7jZqk
	 guWemZ2S4rFQSHe/QTyyw1/BkdgM/Qd690UCsTbDjTlg3txrRcTPSy5k09W9TqQHi/6SV
	 gP+3d738kufYCCu8mEeWT9YpRk1RydWWi0MDSCbf4hCT4bBbtUL/FOpDmJRybxOHQ3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620918;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LRsRAzOjchB0FjeJm4L4F/nCyhLhwTOyYSeZQbP/5CM=;
	b=kMP6178smMCpOwAwt2Au0DWsdbbGUQcOZV8xejLnqHZEhV72uVLam9W0qn3ViVueDB/E
	 EN0Bp3B0rwY6hQbAEydLdyLcw8mQF0yX1gQiRuWMbAHeg+futXaUkNowPAfNpj3/hOiia
	 jq2ypIMMMYfi/xutEkotgbSoTgwGI2VGQ11HvPLyblgB1ccNDAtaFZKVF+Np3PTzOajE3
	 0ujHQFuiYVTrqs/ouPxcJJQ7flGfOBOXqf/pRy8WZEavIYlhlqp3gEeuMJVWnvpg6gTWJ
	 PjDiaROWaxaD6IXqD2Aq3kQ3uEExArMog8axsenGWvjVWaqJe3iyv7cl1TfVv7YHCsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xcJtNHpx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D8B606A337;
	Wed, 25 Nov 2026 15:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xcJtNHpx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96AB31F000D3;
	Wed, 25 Nov 2026 15:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620918;
	bh=LRsRAzOjchB0FjeJm4L4F/nCyhLhwTOyYSeZQbP/5CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xcJtNHpxHynhl/JRaVUo2EyccndODIq1o3JcXdu3FUNwDdHLQS+bDxVoMYd8bZIc2
	 uUI4qf2XQadBRYXiQvGdklmxgGmPPB1qXXTwFtpiuGMrDavfm6F1TKbjHz8D5Z4I3S
	 74FIqhHFQIoe88Svl1UoSfayeFsm5813yk/vJv20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hakan Abay <hakan.abay84@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 019/990] ACPI: PM: Add unused power resource quirk for Casper Excalibur G900
Date: Wed, 25 Nov 2026 15:23:06 +0100
Message-ID: <20261125143822.539567217@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hakan Abay <hakan.abay84@gmail.com>

[ Upstream commit 23ec17231cc6a83bb11d8660db5bfc5336f53a0e ]

On the Casper Excalibur G900, the NVIDIA discrete GPU and the second
NVMe device become inaccessible when unused ACPI power resources are
turned off during initialization.

The failure is similar to the THUNDEROBOT ZERO case addressed by
commit cd7ef20ba8c6 ("ACPI: PM: Add unused power resource quirk for THUNDEROBOT ZERO").

Without the quirk, the NVIDIA GPU and the second NVMe device are left
inaccessible in D3cold and attempts to transition them back to D0 fail.

Add a DMI quirk for the affected Casper Excalibur G900 with NLCC 001
mainboard to leave unused ACPI power resources on.

With the quirk applied, the second NVMe device remains accessible. The
NVIDIA GPU can enter D3cold while idle and subsequently return to D0
for accelerated rendering.

Link: https://bugs.kali.org/view.php?id=9891
Signed-off-by: Hakan Abay <hakan.abay84@gmail.com>
Link: https://patch.msgid.link/20261005174939.53873-1-hakan.abay84@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/power.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index 92cd9f963c6f5..2c0c982602014 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -1139,6 +1139,18 @@ static const struct dmi_system_id dmi_leave_unused_power_resources_on[] = {
 		}
 
 	},
+	{
+		/*
+		 * CASPER EXCALIBUR G900 laptop: Keep unused ACPI power
+		 * resources on to prevent the NVIDIA dGPU and NVMe #2
+		 * from becoming inaccessible.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "CASPER BILGISAYAR SISTEMLERI"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "EXCALIBUR G900"),
+			DMI_MATCH(DMI_BOARD_NAME, "NLCC 001"),
+		},
+	},
 	{}
 };
 
-- 
2.53.0



