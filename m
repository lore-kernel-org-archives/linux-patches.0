Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC74429802;
	Thu, 30 Jul 2026 14:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421962; cv=none; b=gsDzETr36ogGPo71FQ2Evh4ZzjIsd+x0BX2VHneR/28x0DNtLT+eNdDFiozs/VNlIKuL6wJE3HVvjry/jtihOyNYWhJs6hIWFgs/rhM+N7GnB8ufnIHkiPj+4UrCoIVvUtDhWvgx8uWbFYrU0Vb47fz0/h5RQg/rUj5ReXw+FDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421962; c=relaxed/simple;
	bh=WvORtEAU87P7TIPhWoKoh0HegH08f08Edq5SNh2JvKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yw1GSI15iyJWz8v6JW+QJuLJ/G175hzgXgIrboa3TEgVdweE0qZGil+nfym8Ba3aPOB1JuZSYxlPWQy6d7S8sJLksDKlud7UVjYjcGyuO5+8BonyZrD8NT+4GJZYxGy5cf8befLaqs9BECmU2K0thBt/AlRRWZUP70MU1wGXc4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hEdIbaOv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hEdIbaOv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58AB11F000E9;
	Thu, 30 Jul 2026 14:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421960;
	bh=2+xiggcnZRCUufnWD7QQMGX9GBh9FW8IOhY2HoF4eAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hEdIbaOv3aLImSfAogPMaf5lTdbJMQ15CafhGd8cPvUxqrvMiIy2qDS8Dw3sH1j4u
	 MUbDlH7BVT7vDcoLSZxawP02/rAUncHEkyrHuk68PQ/27VnUAVdse7gz/W5gRDXgsC
	 qlJUpO5z1Kc0f3l81HT+YHjH35TUX4A4TmljrRxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Antonio Quartulli <antonio@openvpn.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 279/744] selftests: ovpn: add IPV6 and VETH configs
Date: Thu, 30 Jul 2026 16:09:12 +0200
Message-ID: <20260730141450.219021710@linuxfoundation.org>
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

[ Upstream commit 90c792681a3732caaf7bf5bc435877736baf591a ]

They are required to run the selftests:

 - Tests are executed in v4 and v6.

 - Virtual Ethernet are used between the different netns.

This has not been seen on NIPA before, because the 'ovpn' tests are
executed with the 'tcp_ao' ones, merging their config files. These two
kernel config are present in tools/testing/selftests/net/tcp_ao/config.

This issue is visible when only the ovpn config is used on top of the
default one. This is the recommended way to execute selftest targets.

Fixes: 959bc330a439 ("testing/selftests: add test tool and scripts for ovpn module")
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Acked-by: Antonio Quartulli <antonio@openvpn.net>
Link: https://patch.msgid.link/20260710-net-sft-fix-containers-v1-3-a2915c294ef5@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/ovpn/config | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/ovpn/config b/tools/testing/selftests/net/ovpn/config
index d6cf033d555e70..6b424762e46ee3 100644
--- a/tools/testing/selftests/net/ovpn/config
+++ b/tools/testing/selftests/net/ovpn/config
@@ -4,6 +4,7 @@ CONFIG_CRYPTO_CHACHA20POLY1305=y
 CONFIG_CRYPTO_GCM=y
 CONFIG_DST_CACHE=y
 CONFIG_INET=y
+CONFIG_IPV6=y
 CONFIG_NET=y
 CONFIG_NETFILTER=y
 CONFIG_NET_UDP_TUNNEL=y
@@ -11,3 +12,4 @@ CONFIG_NF_TABLES=m
 CONFIG_NF_TABLES_INET=y
 CONFIG_OVPN=m
 CONFIG_STREAM_PARSER=y
+CONFIG_VETH=y
-- 
2.53.0



