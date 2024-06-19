Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130C8AD58;
	Wed, 19 Jun 2024 13:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802975; cv=none; b=EVr395V5tikZJTncMbp+nD2uSqfTl8OeOPOjNSW/IOVUeWHqzUMNHrdfeHFkRhFtDO/S7Q8ydQrWDfE3DnEdZpnfVXuXsOfseGqakVRpEV8hDx7Mu49cqyAAIupO11zdolDUsZGb0ZHCw7Zn/hGr0jrKtTQh5YrUUudhYR3kPXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802975; c=relaxed/simple;
	bh=ue2bOQ031TXYWHzfJlb2lvGbVnUPV9GSazeEEdfpgUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O8EG+TAkjCaNnE3TfOPq9j2sfUDnC06euuYMR6JexbdU3wIRF/BdTR83z4pjwOOkj5DJ+kPfuypTrpexLJdFO1wdzDuCJtR4x4h0W6Q23EQ64/oJ3erR42bZKtifcETvUIS64GWG9mAKjs07tCSnymdXNNQTqHZaxbbRP2PHzVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Er+1CF/O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Er+1CF/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9DAC2BBFC;
	Wed, 19 Jun 2024 13:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802974;
	bh=ue2bOQ031TXYWHzfJlb2lvGbVnUPV9GSazeEEdfpgUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Er+1CF/OFjXtn46vbxEml4BfuBRYJsYi479JTA9KLL8JVWvTZXUAVC85LDBPZvcmo
	 Q2fzuFOAju0NXs7yTQaFnUEUEpviHJzuk9H9eJHovZYu4DBRmRttM2uFMkpn/VMolc
	 PL90RpCo2m2hh6FOIwn8TfqJOi/PnyWOupJnP3ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danny Lin <danny@kdrag0n.dev>,
	=?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH 6.9 079/281] .editorconfig: remove trim_trailing_whitespace option
Date: Wed, 19 Jun 2024 14:53:58 +0200
Message-ID: <20240619125612.883402628@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 7da9dfdd5a3dbfd3d2450d9c6a3d1d699d625c43 upstream.

Some editors (like the vim variants), when seeing "trim_whitespace"
decide to do just that for all of the whitespace in the file you are
saving, even if it is not on a line that you have modified.  This plays
havoc with diffs and is NOT something that should be intended.

As the "only trim whitespace on modified lines" is not part of the
editorconfig standard yet, just delete these lines from the
.editorconfig file so that we don't end up with diffs that are
automatically rejected by maintainers for containing things they
shouldn't.

Cc: Danny Lin <danny@kdrag0n.dev>
Cc: Íñigo Huguet <ihuguet@redhat.com>
Cc: Mickaël Salaün <mic@digikod.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Fixes: 5a602de99797 ("Add .editorconfig file for basic formatting")
Acked-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/r/2024061137-jawless-dipped-e789@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .editorconfig |    3 ---
 1 file changed, 3 deletions(-)

--- a/.editorconfig
+++ b/.editorconfig
@@ -5,7 +5,6 @@ root = true
 [{*.{awk,c,dts,dtsi,dtso,h,mk,s,S},Kconfig,Makefile,Makefile.*}]
 charset = utf-8
 end_of_line = lf
-trim_trailing_whitespace = true
 insert_final_newline = true
 indent_style = tab
 indent_size = 8
@@ -13,7 +12,6 @@ indent_size = 8
 [*.{json,py,rs}]
 charset = utf-8
 end_of_line = lf
-trim_trailing_whitespace = true
 insert_final_newline = true
 indent_style = space
 indent_size = 4
@@ -26,7 +24,6 @@ indent_size = 8
 [*.yaml]
 charset = utf-8
 end_of_line = lf
-trim_trailing_whitespace = unset
 insert_final_newline = true
 indent_style = space
 indent_size = 2


