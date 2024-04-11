Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40FB5657D3;
	Thu, 11 Apr 2024 10:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831756; cv=none; b=W0fb32oFA9U14L7KwsQGkdYozFQJKzRTSHBKY/eDRhfUvWz/hrEZppMl5jGn7PMKDsEOhyxq7PLt6nlxpUX2+NGXIMbukCLPn3m2j+jdw2y7Lle6BeDJPWyz9V9NKhd7iyIehvDt7+N4kStABqODPRtldQrV4k4sV/TDm2ZiaN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831756; c=relaxed/simple;
	bh=qCRIUKWA/2xHmtyJPxf/4vnDpu4ja6SxPsGQId1av1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQvcn4gOIaHgJ+AJP4eCupv+y4ZpOugsvdvYVrrxIjrr77VpoYvSkP2m79EP2XKB9Nt8h4vjmz/pFHomUR9qD1CnERPRKb1lOA65d2/P34l6DWPpDQKD+dtysdH5suXb1X8CqNxShaNof7MvbJyCPlR9mvlb3mgew/vwK59gTyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=siJ3+YcT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="siJ3+YcT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC86AC433C7;
	Thu, 11 Apr 2024 10:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831756;
	bh=qCRIUKWA/2xHmtyJPxf/4vnDpu4ja6SxPsGQId1av1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=siJ3+YcTC1its6ekaLTaktPL8/5g7alF/hxmghnSTdOmxzuLA9Lv8uSM5eDQrOaz0
	 IyODX5VO8dMAU3JN3V8PIrDF0ZQsxzYXXyRxLzQ2bv1R59JghJvNLkRRLIVd77Q64L
	 +E6WsEeRuDab963Z62RFrHlMkYH+9lqOYSSVO+tY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <ben@decadent.org.uk>,
	Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 5.10 116/294] scripts: kernel-doc: Fix syntax error due to undeclared args variable
Date: Thu, 11 Apr 2024 11:54:39 +0200
Message-ID: <20240411095439.160585532@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Salvatore Bonaccorso <carnil@debian.org>

The backport of commit 3080ea5553cc ("stddef: Introduce
DECLARE_FLEX_ARRAY() helper") to 5.10.y (as a prerequisite of another
fix) modified scripts/kernel-doc and introduced a syntax error:

Global symbol "$args" requires explicit package name (did you forget to declare "my $args"?) at ./scripts/kernel-doc line 1236.
Global symbol "$args" requires explicit package name (did you forget to declare "my $args"?) at ./scripts/kernel-doc line 1236.
Execution of ./scripts/kernel-doc aborted due to compilation errors.

Note: The issue could be fixed in the 5.10.y series as well by
backporting e86bdb24375a ("scripts: kernel-doc: reduce repeated regex
expressions into variables") but just replacing the undeclared args back
to ([^,)]+) was the most straightforward approach. The issue is specific
to the backport to the 5.10.y series. Thus there is as well no upstream
commit for this change.

Fixes: 443b16ee3d9c ("stddef: Introduce DECLARE_FLEX_ARRAY() helper") # 5.10.y
Reported-by: Ben Hutchings <ben@decadent.org.uk>
Link: https://lore.kernel.org/regressions/ZeHKjjPGoyv_b2Tg@eldamar.lan/T/#u
Link: https://bugs.debian.org/1064035
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/kernel-doc |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1233,7 +1233,7 @@ sub dump_struct($$) {
 	# replace DECLARE_KFIFO_PTR
 	$members =~ s/DECLARE_KFIFO_PTR\s*\(([^,)]+),\s*([^,)]+)\)/$2 \*$1/gos;
 	# replace DECLARE_FLEX_ARRAY
-	$members =~ s/(?:__)?DECLARE_FLEX_ARRAY\s*\($args,\s*$args\)/$1 $2\[\]/gos;
+	$members =~ s/(?:__)?DECLARE_FLEX_ARRAY\s*\(([^,)]+),\s*([^,)]+)\)/$1 $2\[\]/gos;
 	my $declaration = $members;
 
 	# Split nested struct/union elements as newer ones


