Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1B28F58
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 15:05:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81818C4339C;
	Mon, 13 Feb 2023 15:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300720;
	bh=d+14hQww7h+iJRMiyu1pvApj5Kgtxp5Fv3agyuZLxJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oOeqdNuAxZ7DoRBjl+WjfAAO8CUHNVK1TGmfhJV/Li7FmObSL0CsEVvEwvepdI1eJ
	 Th16AsMEVp+gFX11cVonHq+ok7Dh4kVoGl1x0fOlHhG8En+7gHUd7tK8GFggvEVVGC
	 cCjkPLU5nnRc/GZxiCyKIV+qweqfbtHan4HQtsYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Petr Machata <petrm@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 122/139] selftests: forwarding: lib: quote the sysctl values
Date: Mon, 13 Feb 2023 15:51:07 +0100
Message-Id: <20230213144752.355711544@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 3a082086aa200852545cf15159213582c0c80eba ]

When set/restore sysctl value, we should quote the value as some keys
may have multi values, e.g. net.ipv4.ping_group_range

Fixes: f5ae57784ba8 ("selftests: forwarding: lib: Add sysctl_set(), sysctl_restore()")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Link: https://lore.kernel.org/r/20230208032110.879205-1-liuhangbin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/lib.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 54020d05a62b8..9605e158a0bfc 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -731,14 +731,14 @@ sysctl_set()
 	local value=$1; shift
 
 	SYSCTL_ORIG[$key]=$(sysctl -n $key)
-	sysctl -qw $key=$value
+	sysctl -qw $key="$value"
 }
 
 sysctl_restore()
 {
 	local key=$1; shift
 
-	sysctl -qw $key=${SYSCTL_ORIG["$key"]}
+	sysctl -qw $key="${SYSCTL_ORIG[$key]}"
 }
 
 forwarding_enable()
-- 
2.39.0



