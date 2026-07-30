Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC71175A6D;
	Thu, 30 Jul 2026 14:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423251; cv=none; b=PZ0Yqq3Z35isyX0a3zR8XMWtfHXTUyBoNCR/rYLiGpzIaH1NrW2GqjcZZIM1sKy9kD9d52hyI6GpOoF/BIvAeg3YpxJH+Wcg+RoIcr/e3Vobym7ftwEavMpqQxwJsWYwjja5+7dlVO4EBNYEbwB6SfsKW/czHNMjf8lo2ECcnVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423251; c=relaxed/simple;
	bh=XuvLIb3OB0B1T2tERfnA5GBfnV8fdp443zPKRp0Rvq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jjntph3s3h3ibSsrsI4xgYYxHip/2vac3sDPvWZpkuTi3xDZBw0Ns4FxOVZjwrYKt5IgRuo90i6IBsvaepWtJxGpaBxGBHxvvJcL/3qPWDEbqtSuXiFs9NsXfTmyfcnPWUpvSJXss31zquzIVPsmrZZ9Lgz8nNePtfa676+AIDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xHhAwwsn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xHhAwwsn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7BE1F000E9;
	Thu, 30 Jul 2026 14:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423250;
	bh=wfw6L2J7ak68rTEkoqRrL6UCYUcHI2o98BWcXOaEZ6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xHhAwwsny0bByfH2BsjMfPs5uHXEpzUj3CnxrqKKhLsLv9cAx0dl+HfGlgBrm+7t/
	 2L1MEJV+yfB1UQ+SH+exv4y2saeArlyKO1bMU5+fV4NkYzviYG2rInh6chEJYlBgHm
	 s+HyQG2rVfVIqQkjH9cNPdfKFgmEleDd5O3I07C0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Wei Wang <weibunny@fb.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 719/744] selftests: drv-net: add missing kconfig for psp.py
Date: Thu, 30 Jul 2026 16:16:32 +0200
Message-ID: <20260730141459.562845667@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit c25dd7439f84cf607e13d6de8cc1c79cd51f56ff ]

This psp.py selftest was failing on my side when only using the
drivers/net config file on top of the default one -- the recommended way
to execute selftest targets.

It looks like some kernel config are needed to execute the new tc
commands.

Note that this was not visible on NIPA, because these tests are executed
with the drivers/net/hw ones, combining the two config files, and the hw
one contains the missing ones.

Fixes: 3f74d5bb807e ("selftests/net: Add env for container based tests")
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Wei Wang <weibunny@fb.com>
Link: https://patch.msgid.link/20260710-net-sft-fix-containers-v1-6-a2915c294ef5@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/config | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/config b/tools/testing/selftests/drivers/net/config
index 2309109a94ecea..4df3f6eef2cbac 100644
--- a/tools/testing/selftests/drivers/net/config
+++ b/tools/testing/selftests/drivers/net/config
@@ -4,11 +4,14 @@ CONFIG_DEBUG_INFO_BTF_MODULES=n
 CONFIG_INET_PSP=y
 CONFIG_IPV6=y
 CONFIG_MACSEC=m
+CONFIG_NET_CLS_ACT=y
+CONFIG_NET_CLS_BPF=y
 CONFIG_NETCONSOLE=m
 CONFIG_NETCONSOLE_DYNAMIC=y
 CONFIG_NETCONSOLE_EXTENDED_LOG=y
 CONFIG_NETDEVSIM=m
 CONFIG_NET_SCH_ETF=m
 CONFIG_NET_SCH_FQ=m
+CONFIG_NET_SCH_INGRESS=y
 CONFIG_VLAN_8021Q=m
 CONFIG_XDP_SOCKETS=y
-- 
2.53.0



