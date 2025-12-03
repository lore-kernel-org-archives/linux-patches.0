Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CCF33DEF4;
	Wed,  3 Dec 2025 16:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779689; cv=none; b=JoHj8l7+/S0iwscTMRU109mTqrmwtt1Mh6HrwlLj3a809bCc3/nXnpzWEr6pudbxrx1vEJzcHutoqaahK2/r1IoagvP2V7bIrHf0ns4/2F4AaUr3qn3mqpfgDf0XkDmIqPsa2z2dyFvwtTOvsonC/FmQfws02MSNBdzhcZtOCys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779689; c=relaxed/simple;
	bh=Y9EgJwpmqdM9CQlkzqBDdwKIkPHvhAdc35CzgQCOZVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2QEqTJnx59rqWUHn/1qTGz5bFRfAlE6bkXMTqGC1zxUQeaj1nIfU+t7zTzOzMQhF5WUcid06HRobM+TZ/lfl656+tuoEAvqZX2Bq3oWBwu4b4yaPzLVRw1YKTsVS8gKEdlcaCoz8Z6otCCeegngx2X0XrHypXgJ6nWzd3OwHRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vI9Hs/tw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vI9Hs/tw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E24EC4CEF5;
	Wed,  3 Dec 2025 16:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779688;
	bh=Y9EgJwpmqdM9CQlkzqBDdwKIkPHvhAdc35CzgQCOZVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vI9Hs/twxaTSPnvV2ikJ4n+CcGXuTGIHLzNcsp53t3ol8scUdD3Pgv3eZpo7sc/Qm
	 FhUm/bDZ+NT0vN/ahZtutLLFmrdoCes0ubDjko3JWhTvivqkRTp0Y9leH+Ar4a1pyQ
	 AFyr3dmXd3Hx+H8FFtlgQGOw1CujENqP8Hh+iXf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 332/568] selftests: netdevsim: set test timeout to 10 minutes
Date: Wed,  3 Dec 2025 16:25:34 +0100
Message-ID: <20251203152452.869235638@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

commit afbf75e8da8ce8a0698212953d350697bb4355a6 upstream.

The longest running netdevsim test, nexthop.sh, currently takes
5 min to finish. Around 260s to be exact, and 310s on a debug kernel.
The default timeout in selftest is 45sec, so we need an explicit
config. Give ourselves some headroom and use 10min.

Commit under Fixes isn't really to "blame" but prior to that
netdevsim tests weren't integrated with kselftest infra
so blaming the tests themselves doesn't seem right, either.

Fixes: 8ff25dac88f6 ("netdevsim: add Makefile for selftests")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/drivers/net/netdevsim/settings |    1 +
 1 file changed, 1 insertion(+)
 create mode 100644 tools/testing/selftests/drivers/net/netdevsim/settings

--- /dev/null
+++ b/tools/testing/selftests/drivers/net/netdevsim/settings
@@ -0,0 +1 @@
+timeout=600


