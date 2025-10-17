Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B802232F75D;
	Fri, 17 Oct 2025 15:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715241; cv=none; b=buQl1BQMh7pR4SALAQ6ewBcujDwWJ6EO5UDtvyl7GTqW9BuC4h91kuZrKmhFMLfQOEQzmAOU7dE9vEK6ecmzFLb378rET9cjl1biObIvY6QFWHP8PpdURx7GoRDOnEDYd9aHy6ArcpWw8QaL3OmsU/zMpEffIsc/8cVF/jKKlpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715241; c=relaxed/simple;
	bh=Qaeo/fvPJKc02q7jW+RtjiEypdW3Ah1iCgS1j9yo6kY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIl/5jar4JrBvQFu1I7ePBMQKItpjzZy435JKBFFVqWGwOqYzCGc77le8ztsDd8T6nrSXpLdt1uHTfYrZxPB0ahGknwgz2DkmvmRR2ki+ErmNmdRonqT+Cm1hoMfgpK17Tmait+eg/Rekv3Fyu4pIEI3K8EPNA9Dgj1jSZPP/D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fwljKspH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fwljKspH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42642C4CEE7;
	Fri, 17 Oct 2025 15:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715241;
	bh=Qaeo/fvPJKc02q7jW+RtjiEypdW3Ah1iCgS1j9yo6kY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fwljKspHJcQ4wQaC8D/w6LpmPjyzmEOs2yUSkiHYETwXADUSY9SsAZdr7ckHvzk+h
	 lWfEMlq/7ZrrNIVAUu5A+jnjXKGcP7wqIpGteN0estlP6mLTJOyfC6kpH7BGGjDRyk
	 lH+wmiPd30xu7UTtQd/veyBjqKcs7HV+6W9RXQo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 6.17 147/371] arm64: dts: ti: k3-am62p: Fix supported hardware for 1GHz OPP
Date: Fri, 17 Oct 2025 16:52:02 +0200
Message-ID: <20251017145207.252899698@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Judith Mendez <jm@ti.com>

commit f434ec2200667d5362bd19f93a498d9b3f121588 upstream.

The 1GHz OPP is supported on speed grade "O" as well according to the
device datasheet [0], so fix the opp-supported-hw property to support
this speed grade for 1GHz OPP.

[0] https://www.ti.com/lit/gpn/am62p
Fixes: 76d855f05801 ("arm64: dts: ti: k3-am62p: add opp frequencies")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-am62p5.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/ti/k3-am62p5.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62p5.dtsi
@@ -135,7 +135,7 @@
 
 		opp-1000000000 {
 			opp-hz = /bits/ 64 <1000000000>;
-			opp-supported-hw = <0x01 0x0006>;
+			opp-supported-hw = <0x01 0x0007>;
 			clock-latency-ns = <6000000>;
 		};
 


