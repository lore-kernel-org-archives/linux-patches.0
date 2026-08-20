Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493A047B438;
	Thu, 20 Aug 2026 16:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243534; cv=none; b=ojUJ16A7lxqu8BqCKpxlkYoAp499G1UeqwJkQEK/lHk03dc/+HbKdnHCkqe4YELKZLCjW+dlFh1QSC/7ihs0v68OfMtD476RlevZ5qo9Vj6h6PBHMwHippgNNSIXS10gN2PeomMhod/CSEBEQdklk/+NHpYPfowfufN8RqlKQLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243534; c=relaxed/simple;
	bh=sY9TrEEezIlKKQBdmh0S0Z+B40D1Xng6I6ctOII1aDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXXcDYE9fvbH3GV46V4CtnEWqPqhwurN4vf6LtKfCVkjQvi1yGCI44emKdASv/PafleLZkO+fp/5izIygLuAp0xTMkEeRdluriobS54GNBc+oTkQmRF+XU94X90pR8Lr1qoFQXOW2D4DR5TxIiGgImLt+w/hc+X2eRdI2qiofgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LuG3Kqo9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LuG3Kqo9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A38871F000E9;
	Thu, 20 Aug 2026 16:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243533;
	bh=HlxCmW/XKHzb59d2dRpEDEh8IJLJSYv0XO7qxIsdX3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LuG3Kqo9Rol1JFHxjrOUFT/UY0IiO4N/BgnGdobnoUzkdaac7/oCuC4fF+/M9GwZL
	 ih3xlzqn71U7iYgzRbglZNDGLN2nG58FYEkkLhUlx5po/HZZS5uE0K32KNDOzDOXwF
	 BjnRuhAk2TlrLjVlOCwyPMdEZ3LohouKF9DfPOu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 128/272] thunderbolt: Update property.c function documentation
Date: Thu, 20 Aug 2026 16:55:12 +0200
Message-ID: <20260820145235.101309398@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

From: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>

[ Upstream commit d015642ad36d78e6eba12d8ab96cea6fd4602b49 ]

Make property.c function documentation compliant with current kernel-doc
standards. No functional changes.

Signed-off-by: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Stable-dep-of: 2c5d2d3c3f70 ("thunderbolt: Prevent XDomain delayed work use-after-free on disconnect")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/property.c |   38 ++++++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 10 deletions(-)

--- a/drivers/thunderbolt/property.c
+++ b/drivers/thunderbolt/property.c
@@ -231,11 +231,13 @@ static struct tb_property_dir *__tb_prop
  *
  * This function parses the XDomain properties data block into format that
  * can be traversed using the helper functions provided by this module.
- * Upon success returns the parsed directory. In case of error returns
- * %NULL. The resulting &struct tb_property_dir needs to be released by
+ *
+ * The resulting &struct tb_property_dir needs to be released by
  * calling tb_property_free_dir() when not needed anymore.
  *
  * The @block is expected to be root directory.
+ *
+ * Return: Pointer to &struct tb_property_dir, %NULL in case of failure.
  */
 struct tb_property_dir *tb_property_parse_dir(const u32 *block,
 					      size_t block_len)
@@ -258,6 +260,8 @@ struct tb_property_dir *tb_property_pars
  *
  * Creates new, empty property directory. If @uuid is %NULL then the
  * directory is assumed to be root directory.
+ *
+ * Return: Pointer to &struct tb_property_dir, %NULL in case of failure.
  */
 struct tb_property_dir *tb_property_create_dir(const uuid_t *uuid)
 {
@@ -501,9 +505,11 @@ static ssize_t __tb_property_format_dir(
  * @block_len: Length of the property block
  *
  * This function formats the directory to the packed format that can be
- * then send over the thunderbolt fabric to receiving host. Returns %0 in
- * case of success and negative errno on faulure. Passing %NULL in @block
- * returns number of entries the block takes.
+ * then sent over the thunderbolt fabric to receiving host.
+ *
+ * Passing %NULL in @block returns number of entries the block takes.
+ *
+ * Return: %0 on success, negative errno otherwise.
  */
 ssize_t tb_property_format_dir(const struct tb_property_dir *dir, u32 *block,
 			       size_t block_len)
@@ -525,9 +531,9 @@ ssize_t tb_property_format_dir(const str
  * tb_property_copy_dir() - Take a deep copy of directory
  * @dir: Directory to copy
  *
- * This function takes a deep copy of @dir and returns back the copy. In
- * case of error returns %NULL. The resulting directory needs to be
- * released by calling tb_property_free_dir().
+ * The resulting directory needs to be released by calling tb_property_free_dir().
+ *
+ * Return: Pointer to &struct tb_property_dir, %NULL in case of failure.
  */
 struct tb_property_dir *tb_property_copy_dir(const struct tb_property_dir *dir)
 {
@@ -597,6 +603,8 @@ err_free:
  * @parent: Directory to add the property
  * @key: Key for the property
  * @value: Immediate value to store with the property
+ *
+ * Return: %0 on success, negative errno otherwise.
  */
 int tb_property_add_immediate(struct tb_property_dir *parent, const char *key,
 			      u32 value)
@@ -626,6 +634,8 @@ EXPORT_SYMBOL_GPL(tb_property_add_immedi
  * @buflen: Number of bytes in the data buffer
  *
  * Function takes a copy of @buf and adds it to the directory.
+ *
+ * Return: %0 on success, negative errno otherwise.
  */
 int tb_property_add_data(struct tb_property_dir *parent, const char *key,
 			 const void *buf, size_t buflen)
@@ -662,6 +672,8 @@ EXPORT_SYMBOL_GPL(tb_property_add_data);
  * @text: String to add
  *
  * Function takes a copy of @text and adds it to the directory.
+ *
+ * Return: %0 on success, negative errno otherwise.
  */
 int tb_property_add_text(struct tb_property_dir *parent, const char *key,
 			 const char *text)
@@ -696,6 +708,8 @@ EXPORT_SYMBOL_GPL(tb_property_add_text);
  * @parent: Directory to add the property
  * @key: Key for the property
  * @dir: Directory to add
+ *
+ * Return: %0 on success, negative errno otherwise.
  */
 int tb_property_add_dir(struct tb_property_dir *parent, const char *key,
 			struct tb_property_dir *dir)
@@ -736,8 +750,10 @@ EXPORT_SYMBOL_GPL(tb_property_remove);
  * @key: Key to look for
  * @type: Type of the property
  *
- * Finds and returns property from the given directory. Does not recurse
- * into sub-directories. Returns %NULL if the property was not found.
+ * Finds and returns property from the given directory. Does not
+ * recurse into sub-directories.
+ *
+ * Return: Pointer to &struct tb_property, %NULL if the property was not found.
  */
 struct tb_property *tb_property_find(struct tb_property_dir *dir,
 	const char *key, enum tb_property_type type)
@@ -757,6 +773,8 @@ EXPORT_SYMBOL_GPL(tb_property_find);
  * tb_property_get_next() - Get next property from directory
  * @dir: Directory holding properties
  * @prev: Previous property in the directory (%NULL returns the first)
+ *
+ * Return: Pointer to &struct tb_property, %NULL if property was not found.
  */
 struct tb_property *tb_property_get_next(struct tb_property_dir *dir,
 					 struct tb_property *prev)


