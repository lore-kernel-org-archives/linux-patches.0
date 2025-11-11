Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FA1330338;
	Tue, 11 Nov 2025 01:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824535; cv=none; b=T0bnlKycF9u9QH4yFHfrS3mhVhalzAUwk9QD3Yq8zEk1GmjTA0HM9eSXuVudifqQD91AcGl3PXvUG0GVufwT/ZOBGjfdfWSyGS1qTjyIMYJO6acTIsG+rV+u3pEv14tW9sXm53wszhZHn31PKtNW++F/KMQZPYVP4X9SbbjPwMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824535; c=relaxed/simple;
	bh=lvAqGYYqTxOlaQun93MN3rTsJOFd7i9QrClj41qqVL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iSghQ9TW5lLL1k5PYiwVi/7lRTs0FE9pnM1QeTgxNaSWi2P0q4SSONEhQzL76aLwWH35JxDXIzg7IglrgnN/0btg7DHB5c4LGP8riUeSY26lwpABjeDz8OdC9kwdoGUkgyg/uwWgRW0tpooVDZXBh1kHQYZMXRU6/A6a52b2vlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OaT/6Z4R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OaT/6Z4R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5D4C4CEFB;
	Tue, 11 Nov 2025 01:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824534;
	bh=lvAqGYYqTxOlaQun93MN3rTsJOFd7i9QrClj41qqVL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OaT/6Z4Rk2j9nKXNkvLio9qzkrLH1bPzJW6UDHHW2HxlvkXWO7HS2AxalArFWy2Jf
	 nyQ4go00unfWsPJJzUk+CZQR0m+/Xa7B0SNL8BNhx3rYDeXQpsFq4+dOSWWYnfmiNQ
	 QA/deOFVjYOyk8NLEQhew/44sM/jyFgwwHfCmdbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 519/849] selftests: Disable dad for ipv6 in fcnal-test.sh
Date: Tue, 11 Nov 2025 09:41:29 +0900
Message-ID: <20251111004548.971565387@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: David Ahern <dsahern@kernel.org>

[ Upstream commit 53d591730ea34f97a82f7ec6e7c987ca6e34dc21 ]

Constrained test environment; duplicate address detection is not needed
and causes races so disable it.

Signed-off-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250910025828.38900-1-dsahern@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/fcnal-test.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index f0fb114764b24..cf535c23a959a 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -424,6 +424,8 @@ create_ns()
 	ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.keep_addr_on_down=1
 	ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.forwarding=1
 	ip netns exec ${ns} sysctl -qw net.ipv6.conf.default.forwarding=1
+	ip netns exec ${ns} sysctl -qw net.ipv6.conf.default.accept_dad=0
+	ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.accept_dad=0
 }
 
 # create veth pair to connect namespaces and apply addresses.
-- 
2.51.0



