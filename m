Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10DBF510;
	Wed,  5 Feb 2025 14:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764315; cv=none; b=dFihysJjx//e0+PzZB4IxpEZ4G6Rl6rbmDWdtyreeb4BEkYrjENaqC8l0qeSsK/b6ZQe1ok/WnYnw9fiy7BSImEbLBHiG+alGAcgQk9gyljZXicxTeWWPbHFRv4iFX3YurPN1QTjXu+oO1fZ2UKUP3b3AGToy/Za8LI5iw1ofow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764315; c=relaxed/simple;
	bh=TpUojswfhPgosK5Lb73slbc3DMctTHMJcvAtDuiYKyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gY0c4du+XO4Le0K1blmxWIOYOiZh2TKuIJJTGANIgWRDOVG7wo/6FEqTLa+k2C6M0hpU3mzesUkTullqa0zqxgWb3iLbtYRWTn2r5PNgRC+qUcegjqxEVr8we7/eUmrQ1g3Z34Xr0vB2EMYuaObNmekc97WC4ytYht8zmAonP6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yd8zOv/5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yd8zOv/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 387F5C4CED1;
	Wed,  5 Feb 2025 14:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764315;
	bh=TpUojswfhPgosK5Lb73slbc3DMctTHMJcvAtDuiYKyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yd8zOv/5ike3yOwMdk8dWSsAY8KOt5vLX57iVze/xSr8edb/8cRqjOx5OA0sN2Gfp
	 BUX19DOMbGUtDvhw85uTORC/znaQ06CLCT3h5iBd0w704Tqxr9nogQfsuaD1kieHnm
	 r56K7NsZlUQ6b3+DUk60lcm2IzbUON+ZGIKfjh20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 112/590] selftests: ktap_helpers: Fix uninitialized variable
Date: Wed,  5 Feb 2025 14:37:47 +0100
Message-ID: <20250205134459.544009660@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mickaël Salaün <mic@digikod.net>

[ Upstream commit 3e707b07f582c12ed78fa5516a97bf701bf0634c ]

__ktap_test() may be called without the optional third argument which is
an issue for scripts using `set -u` to detect uninitialized variables
and potential bugs.

Fix this optional "directive" argument by either using the third
argument or an empty string.

This is required for the next commit to properly test script execution
control.

Cc: Kees Cook <kees@kernel.org>
Cc: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Fixes: 14571ab1ad21 ("kselftest: Add new test for detecting unprobed Devicetree devices")
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Link: https://lore.kernel.org/r/20241212174223.389435-7-mic@digikod.net
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kselftest/ktap_helpers.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kselftest/ktap_helpers.sh b/tools/testing/selftests/kselftest/ktap_helpers.sh
index 79a125eb24c2e..14e7f3ec3f84c 100644
--- a/tools/testing/selftests/kselftest/ktap_helpers.sh
+++ b/tools/testing/selftests/kselftest/ktap_helpers.sh
@@ -40,7 +40,7 @@ ktap_skip_all() {
 __ktap_test() {
 	result="$1"
 	description="$2"
-	directive="$3" # optional
+	directive="${3:-}" # optional
 
 	local directive_str=
 	[ ! -z "$directive" ] && directive_str="# $directive"
-- 
2.39.5



