Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF4135FF4E;
	Wed,  3 Dec 2025 16:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779303; cv=none; b=qCqT1JYhW1g26P7iYtYmlUHU5CAKwuyT5imKEm72VUC2zX8EqniJDC/wpryM4pBPGDJc+KLaXHjNCCtieZRdkiQArRU9sFNLzR9lfuhsG6OdU2m30OL4H9Tl8/BnOFxysxQbN7dzV6xlwvNSEFl1Q5uCDgZpVa2Hsup8/fYZ6ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779303; c=relaxed/simple;
	bh=KtsN93mrf0dQJRl2bhv1J24xiOGCzTl4PtJz3Y4Hd1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l6XXMDNIespJxB/EHsOMNwVn92fV83nQ209QHT2ZYGUHeyUduotIsdtFhBteX080wcmxbIWSZNTzsoq5aaZvTGLLv49Ll74+TKdm5OslDLPtgzeM5qNC0hSutpEyUM6awnsxewiPIyZMtN5J6srvmXopHbKB7Cq4sf2dn9qcQ1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TEwBO8Qv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TEwBO8Qv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0BEC4CEF5;
	Wed,  3 Dec 2025 16:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779303;
	bh=KtsN93mrf0dQJRl2bhv1J24xiOGCzTl4PtJz3Y4Hd1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TEwBO8QvuY4wHIVvh7ISnIMyclBrEAVN1E1ch7nRontdZFmUApepfp9QAEvTwWozZ
	 QK/PefogVvjoKmCDyCN9MAaNK00fm+Hs+JIpq+5oYRZeaRqgQ62YIBNrZpeCzEA1wB
	 FBpsPUquuZ/5p+K4DF5yLhmHBf+1aDX88J/2kQHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 218/568] selftests: Disable dad for ipv6 in fcnal-test.sh
Date: Wed,  3 Dec 2025 16:23:40 +0100
Message-ID: <20251203152448.706625853@linuxfoundation.org>
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
index 1c0dcddbe2bd1..135e19db39eb0 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -423,6 +423,8 @@ create_ns()
 	ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.keep_addr_on_down=1
 	ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.forwarding=1
 	ip netns exec ${ns} sysctl -qw net.ipv6.conf.default.forwarding=1
+	ip netns exec ${ns} sysctl -qw net.ipv6.conf.default.accept_dad=0
+	ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.accept_dad=0
 }
 
 # create veth pair to connect namespaces and apply addresses.
-- 
2.51.0



