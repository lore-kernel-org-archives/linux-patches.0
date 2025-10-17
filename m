Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30378330B04;
	Fri, 17 Oct 2025 15:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716129; cv=none; b=TbfFA4Pz1DCHZChQrdYgvPmb6Mw74IFJo0k20BEzwaJF1+HshHQ4hMdTPCNo6QSEyeMnXq8sJTOlscvbWj2DgZfhM8z7dGHaao/bYxOWggwF5qg1d/pWnfzCIO7HhQROIAvUen9SLz2EPgZSUM09eYuDXs7wgX22NEQe837bxUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716129; c=relaxed/simple;
	bh=wf7JPTHi08JDNh7UDhR+Tg/dpqME9BC0E/zkPk/fRv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hibA+pl+uDgtY4BL6NhY5crTFC+qqHp0X21EGqBWgptqx0+ZwnlOd/iwyBG0cu8qEWyDJN/zTKSJ5qlK640kcD9jysNPZmrClR5KHAQiRK6zH2dM3+Rku7DLlpFDJVpCEB3O+4h34VxXjhi02H6OnDDN5xo9kl9n6szpDgDV7R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y97w/0Kr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y97w/0Kr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC4BC4CEE7;
	Fri, 17 Oct 2025 15:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716129;
	bh=wf7JPTHi08JDNh7UDhR+Tg/dpqME9BC0E/zkPk/fRv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y97w/0KrRK/6Ig35mnL9HRdWHz2Vaqw7GcqcNwcrxG/zRULZcUeqAFt5MwkPEzgK6
	 Qcv7JvbVzxoDymONA+gbI9Q41shFNA7fGhDHUqk0cONpEuzMuclBzRGFgQicxl7afk
	 FEVZFOZlYG5gyJ/yDj8aAyLGKtjVmGeIVKCrIneY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Zanussi <zanussi@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 084/276] Documentation: trace: historgram-design: Separate sched_waking histogram section heading and the following diagram
Date: Fri, 17 Oct 2025 16:52:57 +0200
Message-ID: <20251017145145.552055961@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

From: Bagas Sanjaya <bagasdotme@gmail.com>

[ Upstream commit 8c716e87ea33519920811338100d6d8a7fb32456 ]

Section heading for sched_waking histogram is shown as normal paragraph
instead due to codeblock marker for the following diagram being in the
same line as the section underline. Separate them.

Fixes: daceabf1b494 ("tracing/doc: Fix ascii-art in histogram-design.rst")
Reviewed-by: Tom Zanussi <zanussi@kernel.org>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Message-ID: <20250916054202.582074-5-bagasdotme@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/trace/histogram-design.rst | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/trace/histogram-design.rst b/Documentation/trace/histogram-design.rst
index 088c8cce738ba..6e0d1a48bd505 100644
--- a/Documentation/trace/histogram-design.rst
+++ b/Documentation/trace/histogram-design.rst
@@ -380,7 +380,9 @@ entry, ts0, corresponding to the ts0 variable in the sched_waking
 trigger above.
 
 sched_waking histogram
-----------------------::
+----------------------
+
+.. code-block::
 
   +------------------+
   | hist_data        |<-------------------------------------------------------+
-- 
2.51.0



