Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24AA29CE7;
	Wed,  2 Oct 2024 13:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877194; cv=none; b=AS0YPzeB70LwGraugNVnxQmwcl4RlP9K1foWkO1Kxg6e/DOcN18rlFKHAUPqMQhM7mOE7YtkiQOmWz23o2SgosSFFi+IuPZF/M19dQ2q2fScbjXf+2Mp8gAZjejHqNnmrvVbS9puYtvWcIHKbKxzR2HXs/OQ4jRyUSJz2bWHMFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877194; c=relaxed/simple;
	bh=zWkX/uJcLZNpvaH0ifHB+Q6S8zWic0Ch89e1GatNpPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cEdVehHzmyljl8WNUQt7Gcdw8SNAwNpRkBkJrgIi73uYp/lhlYucMuMO51ri2nLLdQdG7/HHHlz7Fd4N2xifiyQcHNLqor5WHe/PFphnJNMPfzeOsxKDKvHA/HhipgcapW28GtHtPXfBlo0/aKnFAfvGJuXmthvNW0dbdF5yClU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jbZ8X3y0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jbZ8X3y0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D1CC4CEC2;
	Wed,  2 Oct 2024 13:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877194;
	bh=zWkX/uJcLZNpvaH0ifHB+Q6S8zWic0Ch89e1GatNpPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jbZ8X3y0wmvBdSJ0ddlqKe/84tjJrTNzDfm4UdwKkBxbGgrAJLrkM3boq73qXynJA
	 iWvcgkWnvNgiF8F7JnLFFBExijSTFD1LhVcyvQY8VdBdLyRQm7Kq6OjwJI5fTzxuOo
	 5FmQMUh80sPhi15CJ1wHgJQLoJt5nDxvXJnM73rk=
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
Subject: [PATCH 6.11 666/695] serial: qcom-geni: fix arg types for qcom_geni_serial_poll_bit()
Date: Wed,  2 Oct 2024 15:01:04 +0200
Message-ID: <20241002125849.093996062@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



