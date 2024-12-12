Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28CD20A5EE;
	Thu, 12 Dec 2024 17:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024645; cv=none; b=QPm0e8bp07YOc6E1ARyJbu6ClgF8dmnkxkp+xCn2T8QeQlNOCNoOKCHZoZdh6gEabzrObhkhxL+8sWKOF26TBepFjfYxgca3nfQIr5wD+Yvi4dZB+KvUzrsOnBK80v07B9WrtRuhisz/0lVhcXbGXW+9WnCxKmkLCJkX4He6Hkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024645; c=relaxed/simple;
	bh=qvoKOT2bvOVtcqUfiqlYOEhHmdvtDJIkpR7JdL0iqv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPJVqeIRPrsEFWJMbPhD5MEmjQ8v1ytN5a7q+nzMiZDnVULHkpAuLjQdaLghysNKNeV/JU1Q5U6gGUYKx9etB0B+rmXnsFtGnTQJteM3osiBgId02chix8ZsFl9jnByRpLrPQUxxWtkv9v9Ga1i4zRpPLPajEkH/p0cxMdbz80I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tm0AMFPN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tm0AMFPN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56290C4CECE;
	Thu, 12 Dec 2024 17:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024644;
	bh=qvoKOT2bvOVtcqUfiqlYOEhHmdvtDJIkpR7JdL0iqv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tm0AMFPNMyGBwkvnfgBpit+nvT00UoNF8IJ2KTTtWg0dAtCFKrhdI/XCkGGWNY0Qe
	 aBoNa43wAGprfLiiYTG/iAQhVNQG6JootXgWMwvR4FkCNcJM7M4voJZzoV8q1Ha/Mp
	 O6JUlcxxyr5ie3o1DLUf5cUytRXrTNnEPjn1IRtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 347/459] dt_bindings: rs485: Correct delay values
Date: Thu, 12 Dec 2024 16:01:25 +0100
Message-ID: <20241212144307.369209942@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



