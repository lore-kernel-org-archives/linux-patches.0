Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15BA22331E;
	Thu, 12 Dec 2024 17:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023112; cv=none; b=YDB4/BdsWAQM/G2fsxu/v/hse6Eu0+wpbNuAQMUY7ZIqaZApCcgKh4EOsVM+yvZlVqxHPWmxqkKSFmKSCFaysR2Pj/jtfDohF65yb8HnOWPbKnziyjJxFPSMQnXEqlXUdB4PkFotHUAAKRYro9dty0xr8BR4JHpk1xCTqhFJMKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023112; c=relaxed/simple;
	bh=BOw44Ddd7yMlDYuJNMDXewucqNya6YZ4qLgWVH2E6NA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKNzFdLGeCAnvNRw9HwdKrySEeVvttA1w+VlOgxfh/K2JTWmbqQpCVRCH95O0BQyNTmOsYmR1FE6P3kCwUi8rt+t2Xsg+3Iy5sz95pZZq4JuzRqmUbtXNqLYi9uqaV4+sr+D3XZzA8P7VmRuyx5LO/Zhp1ITWdqZwZcy6J8xUcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dbs92sst; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dbs92sst"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60136C4CECE;
	Thu, 12 Dec 2024 17:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023111;
	bh=BOw44Ddd7yMlDYuJNMDXewucqNya6YZ4qLgWVH2E6NA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dbs92sst2QMsR+Ge/bCyP4RNKdinjHdmcm0x4uGl7F62qcvXy0107YR6MbwtbtoRb
	 IL7dApyNNOlW+T16qxeqF75Qe70Ig3nPDgMSVzcTLE2vE62r1ClUKysSBrt5mtAmWy
	 fTgj8VItW3PEAKOrbptvndGnQ6PNWa9NgY2lrA5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 428/565] dt_bindings: rs485: Correct delay values
Date: Thu, 12 Dec 2024 16:00:23 +0100
Message-ID: <20241212144328.598560584@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lino Sanfilippo <l.sanfilippo@kunbus.com>

[ Upstream commit 885dcb08c93d75b784468e65fd4f1f82d5313061 ]

Currently the documentation claims that a maximum of 1000 msecs is allowed
for RTS delays. However nothing actually checks the values read from device
tree/ACPI and so it is possible to set much higher values.

There is already a maximum of 100 ms enforced for RTS delays that are set
via the UART TIOCSRS485 ioctl. To be consistent with that use the same
limit for DT/ACPI values.

Although this change is visible to userspace the risk of breaking anything
when reducing the max delays from 1000 to 100 ms should be very low, since
100 ms is already a very high maximum for delays that are usually rather in
the usecs range.

Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
Link: https://lore.kernel.org/r/20220710164442.2958979-7-LinoSanfilippo@gmx.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 12b3642b6c24 ("dt-bindings: serial: rs485: Fix rs485-rts-delay property")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/serial/rs485.yaml | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/serial/rs485.yaml b/Documentation/devicetree/bindings/serial/rs485.yaml
index 0c9fa694f85c8..518949737c86e 100644
--- a/Documentation/devicetree/bindings/serial/rs485.yaml
+++ b/Documentation/devicetree/bindings/serial/rs485.yaml
@@ -22,12 +22,12 @@ properties:
         - description: Delay between rts signal and beginning of data sent in
             milliseconds. It corresponds to the delay before sending data.
           default: 0
-          maximum: 1000
+          maximum: 100
         - description: Delay between end of data sent and rts signal in milliseconds.
             It corresponds to the delay after sending data and actual release
             of the line.
           default: 0
-          maximum: 1000
+          maximum: 100
 
   rs485-rts-active-low:
     description: drive RTS low when sending (default is high).
-- 
2.43.0



