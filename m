Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56DE28DBB;
	Fri, 24 Nov 2023 18:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ydw0XVSJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773ADC433C7;
	Fri, 24 Nov 2023 18:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851828;
	bh=/ZRF0bZtdxL9bNPKbESou55AUvj2hS8KDui1ACsT9p0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ydw0XVSJHHEEoj/yhFpp6c/DCnEhXV+srcRR2N/rMB7FLei4xt2OQZJL03KbqMKDY
	 uXxF90Rk1ZrIJOKRi9g2A/yNxut5BTMR7s/5WmW1wi/NOF+Jy79Qo70uWVM9CJU5rd
	 HH9my1xBYsUEDXlMFGW3+L++vlAnu57YQySVGcac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 086/372] thunderbolt: Apply USB 3.x bandwidth quirk only in software connection manager
Date: Fri, 24 Nov 2023 17:47:53 +0000
Message-ID: <20231124172013.400005066@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 0c35ac18256942e66d8dab6ca049185812e60c69 ]

This is not needed when firmware connection manager is run so limit this
to software connection manager.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/thunderbolt/quirks.c b/drivers/thunderbolt/quirks.c
index 8c2ee431fcde8..4ab3803e10c83 100644
--- a/drivers/thunderbolt/quirks.c
+++ b/drivers/thunderbolt/quirks.c
@@ -30,6 +30,9 @@ static void quirk_usb3_maximum_bandwidth(struct tb_switch *sw)
 {
 	struct tb_port *port;
 
+	if (tb_switch_is_icm(sw))
+		return;
+
 	tb_switch_for_each_port(sw, port) {
 		if (!tb_port_is_usb3_down(port))
 			continue;
-- 
2.42.0



