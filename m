Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8B63128B9;
	Wed,  3 Dec 2025 16:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777792; cv=none; b=h+Q47wPIG7gDEBrqLD1LHqzLUx6eIklrIEpqZyMI/YIrHcy1WusNNECGBxGD6Cy3sMUDVfUKNkH1hITrvR7FUWAlARphqkYvYrfb6j/UYATl22Vnx/7KNBH6nH0R6h+XyNUKq91FeJoQr5ZI5t+DMUEndE7+y8mpqqACKy+P9zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777792; c=relaxed/simple;
	bh=x09c32tY8egCDKVljZjs8cYS2an2M8sDl8nv3bzHriE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+f4GCxAbdD9CN8IaQ3iB5LlPQJ1s6Flj6VcOeNX60HJwGPuVecfjpNRSprOa4n0sakQnZjDLzFR8He3cLco/LcuEB7Osy+3aJZnJ/scsEqjYsqW8E79tU2+r1ICSR/8r0Qamzp/ANmAQ94ruSSqglYs55vyXrUJuz9GtjItqsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0B52GSvU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0B52GSvU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7B1C4CEF5;
	Wed,  3 Dec 2025 16:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777792;
	bh=x09c32tY8egCDKVljZjs8cYS2an2M8sDl8nv3bzHriE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0B52GSvUjeB1T+6KZkWz6BVz9VTa+Fw5CUu1eXID/0UeDgd/srK/RnjsxsoUO099I
	 NzPlhJi9Ax1269mGTIHRPqbgqitdo66bA5xbbzpuAlMl1a8pj0zuJve5lxFKt11wi7
	 gem53n2FG51PSaa+RCxyfbwOl1rMZetWLN5iBrfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 149/392] selftests: Disable dad for ipv6 in fcnal-test.sh
Date: Wed,  3 Dec 2025 16:24:59 +0100
Message-ID: <20251203152419.567336912@linuxfoundation.org>
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
index bed85001da735..0e43b9e95f4dd 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -409,6 +409,8 @@ create_ns()
 	ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.keep_addr_on_down=1
 	ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.forwarding=1
 	ip netns exec ${ns} sysctl -qw net.ipv6.conf.default.forwarding=1
+	ip netns exec ${ns} sysctl -qw net.ipv6.conf.default.accept_dad=0
+	ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.accept_dad=0
 }
 
 # create veth pair to connect namespaces and apply addresses.
-- 
2.51.0



