Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520094204E;
	Tue, 11 Nov 2025 01:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823035; cv=none; b=pPwHhbkq4oQKMFdcKBSjsUfLzaLb53brhV7QUH74NP3LNGr5m3DkLO9sa3B6K5hElzbyhSyEg5cch/7eyowpgM1tmig9+oWGG5rafMixfrROBILcNMACdE8FONyYG6CSyBKdG1jR0vDn70IkmYIhLkCM+W7dOHKZq4MbA+au1uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823035; c=relaxed/simple;
	bh=LBsbVQdBNXRT2evGwCTQdYzgF4GBfYmL/xxQKN9bhGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjjh4/EYch2K3VKo8Y5IdkqpuZHykJR1KAXF/m54Iaw2CwgfxWXv2UD5ep7kyRPKbNwKVx4ZED7A07PHtXLIHT+3oP/m3hDOqAy16dBp2D2WiHDRD0s5UQl94qDuiBpwDaioWjAy2t3xMD35+9IGeL1JBzTpnl1FTg50BPFLcsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0Z3n+eo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0Z3n+eo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E549BC4CEF5;
	Tue, 11 Nov 2025 01:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823035;
	bh=LBsbVQdBNXRT2evGwCTQdYzgF4GBfYmL/xxQKN9bhGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0Z3n+eoYW7K5Qn5uCymoR424n6GmlBBPN/oxpZTP8iHztPMOSSWSyFIRX1qDZesC
	 sKBE0I/pDxctuxK8GEVAopt59izVnvQhqraXB4Z24w8y6iN2sEgBApYuStQiNRw8ec
	 CvY+Km7wS4LirgoyNYch0ChfjvD2mjDj7/Da6jVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Copeland <ben.copeland@linaro.org>,
	Eugene Shalygin <eugene.shalygin@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 159/565] hwmon: (asus-ec-sensors) increase timeout for locking ACPI mutex
Date: Tue, 11 Nov 2025 09:40:15 +0900
Message-ID: <20251111004530.512402261@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Copeland <ben.copeland@linaro.org>

[ Upstream commit 584d55be66ef151e6ef9ccb3dcbc0a2155559be1 ]

Some motherboards require more time to acquire the ACPI mutex,
causing "Failed to acquire mutex" messages to appear in the kernel log.
Increase the timeout from 500ms to 800ms to accommodate these cases.

Signed-off-by: Ben Copeland <ben.copeland@linaro.org>
Signed-off-by: Eugene Shalygin <eugene.shalygin@gmail.com>
Link: https://lore.kernel.org/r/20250923192935.11339-3-eugene.shalygin@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/asus-ec-sensors.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/asus-ec-sensors.c b/drivers/hwmon/asus-ec-sensors.c
index fdc157c7394d9..483dfb806cc51 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -49,7 +49,7 @@ static char *mutex_path_override;
  */
 #define ASUS_EC_MAX_BANK	3
 
-#define ACPI_LOCK_DELAY_MS	500
+#define ACPI_LOCK_DELAY_MS	800
 
 /* ACPI mutex for locking access to the EC for the firmware */
 #define ASUS_HW_ACCESS_MUTEX_ASMX	"\\AMW0.ASMX"
-- 
2.51.0



