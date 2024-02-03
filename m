Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E6111720;
	Sat,  3 Feb 2024 04:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933942; cv=none; b=Dd6vAU2OWpb0Jkkgn5v7N2LDWHGKOduhwYTLSJtyfVflyRKJIW9djxuPw/xKNaT4hKdDwtvRWt0PiI+pxQECnFBZN7B2BrSICmKlFpJDOcco17ETBceODzkIdWBe2bMiCyCLJSzR+lscpkLv84g4fr4vG14bFr51YhlFCYo4pqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933942; c=relaxed/simple;
	bh=G81OxffNhmdNTczwPnZfrc+Gy+Yv6kWh3LWqLhmctzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sZVLfpwV1KFkLCSbs6ntFhpEuVLMGO0DEi05h7ZDiyjshPypp4AC+KlQUN36VEGk1W4doeXPvuhO/gO+iNPL/T8EHaAKP/JwEXZpY0+hk2xQDEeurBGaOjRuL2lgWAS/RGB6GCnHoPGVwbdGfPzysPi0BYocl9QXUo9rcbBHrto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nrIPKFWQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nrIPKFWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A864C43394;
	Sat,  3 Feb 2024 04:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933942;
	bh=G81OxffNhmdNTczwPnZfrc+Gy+Yv6kWh3LWqLhmctzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nrIPKFWQVO79DXO1W5xNNkG1GxhxM4W3F7em2As+aKGkK06i3BsUJu7PiyL+aD+Os
	 g/006aiGS4ryHjUIYTvJF7nxn8Ue/2RnJ9FVCywjjxHoW+AeRTPgQCLGjix3aY3+Z/
	 lMFqpUVFsu6Gcig/Zf+OfJiZMvLazfV4AN9JeVao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 305/353] selftests: net: add missing required classifier
Date: Fri,  2 Feb 2024 20:07:03 -0800
Message-ID: <20240203035413.490885815@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit d3cb3b0088ca92082e2bebc40cc6894a632173e2 ]

the udpgro_fraglist self-test uses the BPF classifiers, but the
current net self-test configuration does not include it, causing
CI failures:

 # selftests: net: udpgro_frglist.sh
 # ipv6
 # tcp - over veth touching data
 # -l 4 -6 -D 2001:db8::1 -t rx -4 -t
 # Error: TC classifier not found.
 # We have an error talking to the kernel
 # Error: TC classifier not found.
 # We have an error talking to the kernel

Add the missing knob.

Fixes: edae34a3ed92 ("selftests net: add UDP GRO fraglist + bpf self-tests")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Maciej Żenczykowski <maze@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/7c3643763b331e9a400e1874fe089193c99a1c3f.1706170897.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index 413ab9abcf1b..56da5d52674c 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -51,6 +51,7 @@ CONFIG_NETFILTER_XT_MATCH_LENGTH=m
 CONFIG_NET_ACT_CT=m
 CONFIG_NET_ACT_GACT=m
 CONFIG_NET_CLS_BASIC=m
+CONFIG_NET_CLS_BPF=m
 CONFIG_NET_CLS_U32=m
 CONFIG_NET_IPGRE_DEMUX=m
 CONFIG_NET_IPGRE=m
-- 
2.43.0



