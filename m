Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27A1313558;
	Wed,  3 Dec 2025 16:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778054; cv=none; b=JEzwL+vTcXPOSvflf4x9vq0ldWW6Q/IGRzCmSsHD+dj2WxusQynpziNB8XkRG/VwYhHUWjN8oGmTiicwsMQG9EwA6rATmkxaRiK5f/0x50jfCo27uOSxLCfj8pMBkdMW/W6PQrjWVitT+9nTXjrQO/NuiKto0Y7fFZds9sI1ZQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778054; c=relaxed/simple;
	bh=Lu83OpVvrjR6fnu5Qq00tSDUy1sxgkUkH1q55TgBx/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C4eW6so44XBMHLfoagW26yqdXc8CdpsMjE+vtGVeHEf7TFpPkh4nHKi0knsjTxyclI78z1W72flvCQPbqGRMHjAilL8V8mqWTr4nk1LtQyMGy0yTMIGc9AOxiBY0yAq9KbAwVu0TYfpfgyGbj7Dqh3M6kt48sBHe4a4nNKwJ6ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xu4GRZEJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xu4GRZEJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558F4C4CEF5;
	Wed,  3 Dec 2025 16:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778054;
	bh=Lu83OpVvrjR6fnu5Qq00tSDUy1sxgkUkH1q55TgBx/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xu4GRZEJOP3vw2JMVhHer9viL/dfR1xP1JBwGbsSolfxj2i/LaNtdoZYrR8SG0RG4
	 f8IdE9R7MS5p6/pVk22CYZ9wAjNgWxFvyqckm2IdkutzULg/U2S+eyj/paOtBjNmQu
	 qPvaeRm4vsARd4iSsgsCDhTLsvdjBKkvGWejA01A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 229/392] selftests: netdevsim: set test timeout to 10 minutes
Date: Wed,  3 Dec 2025 16:26:19 +0100
Message-ID: <20251203152422.609748217@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


