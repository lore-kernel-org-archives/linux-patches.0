Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818E527B359;
	Wed,  4 Feb 2026 14:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216658; cv=none; b=lJwNPuua4GOBBwKcJ4HPyzpcYi53HnfljBnlsXP66SYVTdzfn5YN1utysCBPAycXrftpt1lwL+/Qe3ulG/FYSX9azLCbevLLRPvuc920ZqiySFdNjOJg4HRsI2eM2A9sSDjR2RL1iv9Smslu12frBwircHsPYCcwcirP+jHltj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216658; c=relaxed/simple;
	bh=h/fWJaeif3ukjKRBlvHats0uq2CT7HlPVLaMIRLqgXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WAnrYBOMbKWimPj82m1C+LnqI22wNP3vTIeevTQWDVWHjrFbb9l7fJHek2yGZLv1cVH6VPYOO0H2/lveQApnlm5Hi+28IfCp50xmd1GrNjZx124fkqFJ2XeNaiDGo8QvEGY2j1hx8noOTiBu42Lgw4PYVJ27FubRfmRRkG8jQYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=060mv8/f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="060mv8/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C104C4CEF7;
	Wed,  4 Feb 2026 14:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216658;
	bh=h/fWJaeif3ukjKRBlvHats0uq2CT7HlPVLaMIRLqgXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=060mv8/fJl0s9nlhcAUkDsEnS5NnPPy1edTDyIJtOkouJ+SSv0QXrI5wbuD5pfzHA
	 1PCtKyBGZneD86TnlWgdEIrk5jkqXmTVJZjAUH05samN2jxPCGD5SKBxGBuRjQXBop
	 r7NJalQyg9JgZUX5yT0uwQBRBHOivcU1Ja0rvVX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <ben@decadent.org.uk>,
	David Ahern <dsahern@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 154/161] Revert "selftests: Replace sleep with slowwait"
Date: Wed,  4 Feb 2026 15:40:17 +0100
Message-ID: <20260204143857.288131968@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 780095c51e34ec7cdf6f651b4c4f2b35680779e4 which is
commit 2f186dd5585c3afb415df80e52f71af16c9d3655 upstream.

To quote Ben:
	The slowwait function isn't defined in 5.10 (or any stable
	branch older than 6.9).

Link: https://lore.kernel.org/r/b052b71589bb576dcad441eba38c20da81443a46.camel@decadent.org.uk
Reported-by: Ben Hutchings <ben@decadent.org.uk>
Cc: David Ahern <dsahern@kernel.org>
Cc: Simon Horman <horms@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/fcnal-test.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -183,7 +183,7 @@ show_hint()
 kill_procs()
 {
 	killall nettest ping ping6 >/dev/null 2>&1
-	slowwait 2 sh -c 'test -z "$(pgrep '"'^(nettest|ping|ping6)$'"')"'
+	sleep 1
 }
 
 do_run_cmd()


