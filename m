Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE00C1D1319;
	Wed,  2 Oct 2024 14:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879003; cv=none; b=sNWh53aKekHp68Xy2fqS0CMxXu64sJTYXQrI2bZXN558ZWGSokVnE7OarrdTpcQuESw/bt2sWKrBmh26kJqZOWVm4YZDsYig1nXZDsNN+GPnu1jQ3XbwVSgUCLAqbAlvBaRuPIoiHXCiIVwr6ap9L+DMuTBscWuN/5lL7yNfqGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879003; c=relaxed/simple;
	bh=zdipsinB0j/tOUOoScmNN8T7eupm6BRLPPvXaZpri60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BQ2IO5SyNbNwLEzw7SF4sdTmX1cX+CHogV7CM0tIZuHO8QHN985zo6qLuhYRQ9uTgWUR6h50uSBsjc4M1Byq6rGTQhxx5e87MH04wP3xdUvdofeY0SRiZg5qPgaZ/ECCpGSc1MpJne96NdFINRNfNF9tUvNavMd/4I1IYg2EIEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ekZxbGuB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ekZxbGuB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E964C4CECE;
	Wed,  2 Oct 2024 14:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879003;
	bh=zdipsinB0j/tOUOoScmNN8T7eupm6BRLPPvXaZpri60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ekZxbGuBNK7fWCO1N83UQTLLiPlYuxeFTpunHROsW93HyhNNLMcvXBpBM5AMNErRy
	 zlj2bKVzOivIHKrkw/9AzfP67yG0QQlrxeK0qNJhiG/mAVYn7tHUADFf0j3BzVgrtX
	 AB7NpOhkYXFBh9JwnSbvfmx9Ct080ggpgb2dj3xA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Boyd <swboyd@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 604/634] serial: qcom-geni: fix arg types for qcom_geni_serial_poll_bit()
Date: Wed,  2 Oct 2024 15:01:44 +0200
Message-ID: <20241002125834.956232805@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit c2eaf5e01275ae13f1ec5b1434f6c49cfff57430 ]

The "offset" passed in should be unsigned since it's always a positive
offset from our memory mapped IO.

The "field" should be u32 since we're anding it with a 32-bit value
read from the device.

Suggested-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240610152420.v4.4.I24a0de52dd7336908df180fa6b698e001f3aff82@changeid
Tested-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20240906131336.23625-5-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: cc4a0e5754a1 ("serial: qcom-geni: fix console corruption")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/qcom_geni_serial.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/qcom_geni_serial.c b/drivers/tty/serial/qcom_geni_serial.c
index b88435c0ea507..54052c68555d7 100644
--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -266,7 +266,7 @@ static bool qcom_geni_serial_secondary_active(struct uart_port *uport)
 }
 
 static bool qcom_geni_serial_poll_bit(struct uart_port *uport,
-				int offset, int field, bool set)
+				      unsigned int offset, u32 field, bool set)
 {
 	u32 reg;
 	struct qcom_geni_serial_port *port;
-- 
2.43.0



