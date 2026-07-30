Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F53372ECB;
	Thu, 30 Jul 2026 15:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424031; cv=none; b=dUadQvQKxbUlDZ4DK6pYDAYxcJIfbLnYtKBMSFjJETte97cOtjOcU0Gl6hcLk9Oi1Lz57ZCEmY7B8xQbe8EXqqi0oDATSyj9QbXC0X91AwCcvnmfX1AWssEcjPgVaNP8GC2QZCDD3Wo0QgWoKbzGX5QACzLvH/NQPdD/1oVcWwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424031; c=relaxed/simple;
	bh=BOPDQC6LTMU30k4Xo0jg2Ms4Szr7NWtznKW6mvMsJW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M32PPevnBidNnue2Z5EGSfn2hhsPJtp17GZVLqJ75iuez5zla9d06TuOQjFv/4XnB5BAGtvBSlPBtgehvSmeeK6FwLYEH5BDejwPbWecReRGR4Yc584LBwSleUUKaFuS2/x00bGOqGdJRWETI4O+kfv1tJ7XR2g8kcp2WpEoT/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AlAt+lMe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AlAt+lMe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20421F000E9;
	Thu, 30 Jul 2026 15:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424030;
	bh=Bb3Yv5KUuUvD0+NxF2khKBuvpolvJ07nXLUoxshu2/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AlAt+lMeAcrcLR4tNB7Lq0V8AdYkyIsvA3rmpjDV4W+Pa1TR0TlsTHbMlqZZ/mDIt
	 KD96oAWo0VHgGEefAM3brX5UMjYT0zFN2x3+r7u7VgFaULE8LMrTsI6gpinWJNggVz
	 b7QS4gehm/Z+Lwn9cpwbD7Z4zG1MbVsPsKMW8Ykg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Antonio Quartulli <antonio@openvpn.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 250/675] selftests: ovpn: add IPV6 and VETH configs
Date: Thu, 30 Jul 2026 16:09:40 +0200
Message-ID: <20260730141450.451453451@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 42699740936dba..c0a21a43018a22 100644
--- a/tools/testing/selftests/net/ovpn/config
+++ b/tools/testing/selftests/net/ovpn/config
@@ -4,7 +4,9 @@ CONFIG_CRYPTO_CHACHA20POLY1305=y
 CONFIG_CRYPTO_GCM=y
 CONFIG_DST_CACHE=y
 CONFIG_INET=y
+CONFIG_IPV6=y
 CONFIG_NET=y
 CONFIG_NET_UDP_TUNNEL=y
 CONFIG_OVPN=m
 CONFIG_STREAM_PARSER=y
+CONFIG_VETH=y
-- 
2.53.0



