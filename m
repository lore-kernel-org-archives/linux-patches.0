Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2235131078B;
	Mon, 13 Oct 2025 15:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369794; cv=none; b=a81O4j7ZSEPxUkcRGZhlxogZNzeJjLvRDhJSXe3jiqqKKpurtIjQIFMk/C1zBYiufLy6EjDcmZ9F59HIQudUokU28MTA4JYRW4uJWFhhwh174u07k4R3pzjU3N03U4yaQfNTIMHjDSe95C+6DWONnQxX0NZfOt5meOmJ5BH0GpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369794; c=relaxed/simple;
	bh=SiPmHXOQQDYAHH+ggc0b7UbTXO7WqpfBBsJ4EcG4Knw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rhBjd42OascVA7hbuHJVE255CBjYcsgEWLI7RDUg7LTmYZiNsXsOd39TvoOSf4DJLzAmGUZ6bXBCLVPCGU+9WBTL0Jv6le+bt2nInnoB7wVQTnRN0K0+4EWERsu/eJ/WTQkddGcn6G+zTiHYkHEn1kBT5SWGKu0Ey3u2maneBkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l/7zOTVG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l/7zOTVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B67C4CEFE;
	Mon, 13 Oct 2025 15:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369793;
	bh=SiPmHXOQQDYAHH+ggc0b7UbTXO7WqpfBBsJ4EcG4Knw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l/7zOTVG+bhfcdTzbHMwkQDBH4E//T4my62IdhTNJKLJVs8UL4LLb+iTGljt3QgIU
	 A+hS34F+tbfDVbetVRSYdzyIlczHRWD15pFQ74DJHMvB5evXCPA3bTHb4QohzWYEgm
	 IJoRcq+Do9pKTda89hqbaOqfw/Xwudu9lN7An6yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Donald Hunter <donald.hunter@gmail.com>,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 343/563] tools: ynl: fix undefined variable name
Date: Mon, 13 Oct 2025 16:43:24 +0200
Message-ID: <20251013144423.696535399@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit 7a3aaaa9fce710938c3557e5708ba5b00dd38226 ]

This variable used in the error path was not defined according to Ruff.
msg_format.attr_set is used instead, presumably the one that was
supposed to be used originally.

This is linked to Ruff error F821 [1]:

  An undefined name is likely to raise NameError at runtime.

Fixes: 1769e2be4baa ("tools/net/ynl: Add 'sub-message' attribute decoding to ynl")
Link: https://docs.astral.sh/ruff/rules/undefined-name/ [1]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
Reviewed-by: Asbjørn Sloth Tønnesen <ast@fiberby.net>
Link: https://patch.msgid.link/20250909-net-next-ynl-ruff-v1-1-238c2bccdd99@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/ynl/pyynl/lib/ynl.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/net/ynl/pyynl/lib/ynl.py b/tools/net/ynl/pyynl/lib/ynl.py
index 8244a5f440b2b..15ddb0b1adb63 100644
--- a/tools/net/ynl/pyynl/lib/ynl.py
+++ b/tools/net/ynl/pyynl/lib/ynl.py
@@ -746,7 +746,7 @@ class YnlFamily(SpecFamily):
                 subdict = self._decode(NlAttrs(attr.raw, offset), msg_format.attr_set)
                 decoded.update(subdict)
             else:
-                raise Exception(f"Unknown attribute-set '{attr_space}' when decoding '{attr_spec.name}'")
+                raise Exception(f"Unknown attribute-set '{msg_format.attr_set}' when decoding '{attr_spec.name}'")
         return decoded
 
     def _decode(self, attrs, space, outer_attrs = None):
-- 
2.51.0



