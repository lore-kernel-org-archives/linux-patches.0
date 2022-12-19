Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AAE46FB4
	for <patches@lists.linux.dev>; Mon, 19 Dec 2022 19:26:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF8CC433EF;
	Mon, 19 Dec 2022 19:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1671478005;
	bh=HvNKuWYFW8umeX/fI6aXrzjdk4JcPKrYu3UMnlPw/N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QrFuIMG94nIr6f3DuEh2+ZfabVjffzNMx71av+xM1Yo30tHK4moollx53XimtpUSn
	 hVijDTnjlS5c4vUD1N/kXJv5t2Wa/yeKlONs8dTTa6iuWkEPMTzdGVxq6PHYi0DDMw
	 eB0KOWa6vbgM5jRYV/TD3i3oaOxubnbTTGlnac8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 27/28] selftests: net: Use "grep -E" instead of "egrep"
Date: Mon, 19 Dec 2022 20:23:14 +0100
Message-Id: <20221219182945.343897724@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182944.179389009@linuxfoundation.org>
References: <20221219182944.179389009@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 6a30d3e3491dc562384e9f15b201a8a25b57439f ]

The latest version of grep claims the egrep is now obsolete so the build
now contains warnings that look like:
	egrep: warning: egrep is obsolescent; using grep -E
fix this using "grep -E" instead.

  sed -i "s/egrep/grep -E/g" `grep egrep -rwl tools/testing/selftests/net`

Here are the steps to install the latest grep:

  wget http://ftp.gnu.org/gnu/grep/grep-3.8.tar.gz
  tar xf grep-3.8.tar.gz
  cd grep-3.8 && ./configure && make
  sudo make install
  export PATH=/usr/local/bin:$PATH

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Link: https://lore.kernel.org/r/1669864248-829-1-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/toeplitz.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/toeplitz.sh b/tools/testing/selftests/net/toeplitz.sh
index 0a49907cd4fe..da5bfd834eff 100755
--- a/tools/testing/selftests/net/toeplitz.sh
+++ b/tools/testing/selftests/net/toeplitz.sh
@@ -32,7 +32,7 @@ DEV="eth0"
 # This is determined by reading the RSS indirection table using ethtool.
 get_rss_cfg_num_rxqs() {
 	echo $(ethtool -x "${DEV}" |
-		egrep [[:space:]]+[0-9]+:[[:space:]]+ |
+		grep -E [[:space:]]+[0-9]+:[[:space:]]+ |
 		cut -d: -f2- |
 		awk '{$1=$1};1' |
 		tr ' ' '\n' |
-- 
2.35.1



